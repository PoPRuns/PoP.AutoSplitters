- [Introduction](#introduction)
- [ASL](#asl)
  - [Action Variables](#action-variables)
  - [Writing Methods](#writing-methods)
    - [Notation](#notation)
    - [Inlining](#inlining)
    - [Recursion](#recursion)
    - [Closures](#closures)
    - [Garbage Collection](#garbage-collection)
    - [Which Block?](#which-block)
    - [Action Variables](#action-variables-1)
  - [Records, Structs, and Tuples](#records-structs-and-tuples)
    - [Tuple Basics](#tuple-basics)
    - [Reference Tuple vs. Value Tuple](#reference-tuple-vs-value-tuple)
    - [Nullable Types](#nullable-types)
    - [Equality Comparisons](#equality-comparisons)
- [Settings and Events](#settings-and-events)
- [Hashing](#hashing)
  - [Hashing Algorithm](#hashing-algorithm)
  - [`BucketSize` Choice](#bucketsize-choice)

# Introduction
This is a documentation of how some ASL features work, as well as how some of our specific autosplitters work, along with justifications for why they were chosen to be designed as they were. This document is not exhaustive of all of our autosplitters, as many of them are old and use outdated techniques, but this document could serve as a guide for how to update them. Conversely, some newer autosplitters justifiably use different techniques from the ones proposed in this document, but this document could still be useful as a guide for how to improve them.

This document is human-written.
# ASL
### [ASL Documentation](https://github.com/LiveSplit/LiveSplit.AutoSplitters)
### [.NET Documentation](https://learn.microsoft.com/en-us/dotnet/api/?view=netframework-4.8.1)
ASL uses .NET Framework 4.8.1.

This document explains some niche yet highly important aspects of working with ASL that aren't covered in the official documentation, though it is assumed that the reader already has a basic understanding of ASL, .NET, and programming in general.

To see a concrete implementation of the techniques discussed in this section, refer to the [Prince of Persia 2008](pop_2008.asl) autosplitter.
## Action Variables
The ASL *action variables* (`old`, `current`, `settings`, etc.) are accessible from all code blocks, thus giving the appearance that these variables are global. However, they are not global at all.

LiveSplit does store global action variables in the backend, but we do not have direct access to those from our ASL script. Rather, each code block is actually a method with these action variables as parameters, and LiveSplit merely passes a copy of the values of the global action variables when it invokes an ASL code block, so actually each code block gets its own local action variables that are completely independent from all other local action variables in all other code blocks, and even from the local action variables in a subsequent call of the same code block.

If an action variable is of a reference type, then the variable does not contain the object itself but rather a pointer to the object, in which case mutating the object in one code block will also cause another code block to perceive a mutation of that object, unless the local action variable in the other code block points to `null` or a different object. For example, since the `timer` variable is of a reference type, mutating the timer object from any code block will result in all code blocks perceiving the change, since all code blocks are given the same pointer to the global timer object when their respective local `timer` variable is assigned upon invocation. (So the `timer` variable itself is a local variable, but it contains a pointer to the global timer object. Notably, one can overwrite a local `timer` variable so that it points to `null` or a different object - e.g. `timer = null;`, but this will not cause any change once that block finishes executing. The next time that code block is invoked, the local `timer` variable will again contain a pointer to the global timer object.)

Further, the variables `refreshRate` and `version` give an illusion of being global because once the execution of some code blocks finishes, LiveSplit reads the values of these local variables and overwrites the corresponding global variables with the updated values. For `refreshRate` this is done after the execution of every code block, whereas for `version` this is only done after the execution of the `init` block.

Finally, the local `settings` variable does not even correspond to any global settings variable at all, but rather there are two global settings variables: a settings *builder* variable, and a settings *reader* variable. When the `startup` block is invoked, a copy of the pointer to the settings *builder* object is passed to the local `settings` variable. When any other code block is invoked, a copy of the pointer to the settings *reader* object is passed to the local `settings` variable.

For more information, see the [`LiveSplit.ASL.ASLScript`](https://github.com/LiveSplit/LiveSplit.ScriptableAutoSplit/blob/master/src/LiveSplit.ScriptableAutoSplit/ASL/ASLScript.cs) class, as well as all the classes in that namespace (folder).
## Writing Methods
### Notation
ASL does not natively support writing methods. In vanilla C#, we can simply write:
```c#
void DoSomething()
{
    // do something...
}

int ReturnSomething(float param1, bool param2)
{
    int ret = 0;
    // compute ret...
    return ret;
}

DoSomething();
int myInt = ReturnSomething(5f, false);
```
But in ASL this code would not compile. Instead, we would have to write something like:
```c#
Action DoSomething = () =>
{
    // do something...
};

Func<float, bool, int> ReturnSomething = (param1, param2) =>
{
    int ret = 0;
    // compute ret...
    return ret;
};

DoSomething();
int myInt = ReturnSomething(5f, false);
```
An `Action` type denotes a method that does not return any value (i.e. returns `void`) and has zero parameters. An `Action<T1, T2, ...>` type denotes a method that does not return any value and accepts parameters of types `T1`, `T2`, etc. For example a method that takes an `int` and a `string` as parameters and returns nothing would be of type `Action<int, string>`.

A `Func<TResult>` type denotes a method that returns a value of type `TResult` and has zero parameters. A `Func<T1, T2, ..., TResult>` type denotes a method that returns a value of type `TResult` and has parameters of types `T1`, `T2`, etc. For an example, see the `ReturnSomething` method above.
### Inlining
In C#, when we write methods using the standard notation (e.g. `void DoSomething() { }`), the compiler automatically performs optimisations for composite method calls. For example, consider the following methods:
```c#
bool InBounds(float min, float max, float pos) => pos >= min && pos <= max;

bool InXBoundsOld(float min, float max) => InBounds(min, max, old.xPos);
bool InYBoundsOld(float min, float max) => InBounds(min, max, old.yPos);
bool InZBoundsOld(float min, float max) => InBounds(min, max, old.zPos);

bool InPosWithBoundsOld(float xMin, float xMax, float yMin, float yMax, float zMin, float zMax)
=>
    InXBoundsOld(xMin, xMax) &&
    InYBoundsOld(yMin, yMax) &&
    InZBoundsOld(zMin, zMax);
```
So the `InXBoundsOld`, `InYBoundsOld`, and `InZBoundsOld` methods themselves call the `InBounds` method. Further, the `InPosWithBoundsOld` method calls each of these three methods, and each of those then calls another method, thus creating a total of 7 method invocations. However, this is inefficient since it involves generating space on the stack for each new method, copying the `min` and `max` arguments, and then doing three returns instead of one. But the C# compiler will automatically optimise this and perform an inlining, such that when the code is compiled, instead of `InPosWithBoundsOld` calling `InXBounds`, `InYBounds`, and `InZBounds`, and each of these in turn calling `InBounds`, it instead performs the operations of `InXBounds`, `InYBounds`, `InZBounds`, and `InBounds` directly. So the methods above would actually compile down to:
```c#
bool InBounds(float min, float max, float pos) => pos >= min && pos <= max;

bool InXBoundsOld(float min, float max) => old.xPos >= min && old.xPos <= max;
bool InYBoundsOld(float min, float max) => old.yPos >= min && old.yPos <= max;
bool InZBoundsOld(float min, float max) => old.zPos >= min && old.zPos <= max;

bool InPosWithBoundsOld(float xMin, float, xMax, float yMin, float yMax, float zMin, float zMax)
=>
    old.xPos >= xMin && old.xPos <= xMax &&
    old.yPos >= yMin && old.yPos <= yMax &&
    old.zPos >= zMin && old.zPos <= zMax;
```
However, since we cannot define compile-time methods in ASL but instead are forced to assign lambda expressions to local variables, the compiler does not automatically perform inlining optimisations. Therefore, for small methods on a hot path (that is, methods that get called every cycle) such as coordinate checks, it is good practice to perform inlining manually in order to improve performance.

This should only be done for small methods, as copying large methods repeatedly is cumbersome and in general is not recommended as it bloats the compiled machine code which occupies more memory (though for an autosplitter it is unlikely that this would have a significant effect). Likewise for methods that only get called once or rarely, this is not needed.

So when designing small methods on a hot path, instead of having a chain of several method calls, it is better to simply write out the operations behind the method calls. Therefore, for the above methods, in ASL we would write optimised code as follows:
```c#
Func<float, float, float, bool> InBounds = (min, max, pos) => pos >= min && pos <= max;

Func<float, float, bool> InXBoundsOld = (min, max) => old.xPos >= min && old.xPos <= max;
Func<float, float, bool> InYBoundsOld = (min, max) => old.yPos >= min && old.yPos <= max;
Func<float, float, bool> InZBoundsOld = (min, max) => old.zPos >= min && old.zPos <= max;

Func<float, float, float, float, float, float, bool> InPosWithBoundsOld = (xMin, xMax, yMin, yMax, zMin, zMax)
=>
    old.xPos >= xMin && old.xPos <= xMax &&
    old.yPos >= yMin && old.yPos <= yMax &&
    old.zPos >= zMin && old.zPos <= zMax;
```
Although this can be a bit cumbersome, it only has to be done once and only for small methods on a hot path, so it is very manageable.
### Recursion
Since our methods are merely lambdas assigned to local variables, the functions can only have references to other local variables that were declared and initialised before the lambdas themselves. As such, a method cannot have a reference to any variables (including other functions) declared and initialised below itself. So for example, the following code compiles just fine:
```c#
Action DoSomethingFirst = () =>
{
    // do something first...
};

Action DoSomething = () =>
{
    DoSomethingFirst();
    // do something next...
};

DoSomething();
```
However, if we wrote those methods in reverse order, then the code would not compile since `DoSomething` has a reference to `DoSomethingFirst` which would not yet be declared at the time when `DoSomething` is defined. In this case, this is not an issue, since we can simply write them in the correct order, as shown above. Most of the time, it is very easy to simply reorder our methods and data so that variables that are referred to are above variables that are doing the referring. But sometimes we may wish to implement recursion, where two functions refer to each other, or even one function refers to itself. See such recursive examples below:
```c#
Func<int, int> Decrease1 = null;
Func<int, int> Decrease2 = null;
Func<int, int> Decrease3 = null;

Decrease1 = num =>
{
    num -= 1;
    print(num.ToString());
    return num <= 0 ? num : Decrease2(num);
};

Decrease2 = num =>
{
    num -= 2;
    print(num.ToString());
    return num <= 0 ? num : Decrease1(num);
};

Decrease3 = num =>
{
    num -= 3;
    print(num.ToString());
    return num <= 0 ? num : Decrease3(num);
};

Decrease1(20);
Decrease3(20);
```
Here `Decrease1` calls `Decrease2` and `Decrease2` calls `Decrease1` until the number they are passing comes down to 0. Likewise, `Decrease3` calls itself until the number it is passing comes down to 0. The above code compiles and works as expected, printing the following numbers on separate lines: `19`, `17`, `16`, `14`, `13`, `11`, `10`, `8`, `7`, `5`, `4`, `2`, `1`, `-1`, `17`, `14`, `11`, `8`, `5`, `2`, `-1`. This is because the `Decrease1`, `Decrease2`, and `Decrease3` variables are all declared and initialised above any of the actual method definitions. So although `Decrease2` has a value of `null` at the time `Decrease1` is defined, this does not matter because by the time `Decrease1` is actually called, `Decrease2` already has a non-null value and contains a perfectly valid function.
### Closures
As the above example shows, when a defined lambda function references a variable that is outside of the lambda function, it uses the value that the variable has at the time of the function call, and not at the time of the lambda being defined. But what if the lambda function is called after the code block finishes executing, and that code block's stack frame has popped? For example, what if we store the lambda in a global variable like `vars.myFunction` and then call it after the code block finishes executing and its stack frame has popped? How does it still retain references to variables that have seemingly already popped from the stack?

The answer is that the compiler creates what is called a *closure*.

Any variables within the code block that are captured by any lambda do not live on the stack in the first place. Instead, when the code block starts, a closure object is allocated on the heap, and all variables from that code block that are referenced by any lambda get placed inside that object on the heap instead of on the stack. Thus, when the code block finishes executing and the stack frame pops, those variables that are referenced by lambdas remain accessible on the heap. Notably, this happens even if the lambda itself never leaves the stack.
### Garbage Collection
When an object is allocated on the heap (such as a list, hashset, dictionary, or any other object that lives on the heap), the .NET runtime keeps track of whether any references to that object from anywhere within the program remain, and once there are zero references to a particular object, it gets automatically freed from the heap. This is called garbage collection. In lower-level languages like C we need to free our objects manually to avoid memory leaks, but C# does it for us as soon as we stop referring to an object, indicating that we no longer need it.

However, there is a catch for our ASL scripts specifically. Namely, because we can't define real methods and instead end up defining a bunch of lambdas - whether in one code block or another - any variables that are captured by those lambdas continue to live on the heap even after the code block finishes executing, and even if we don't need them anymore.

Therefore, if we allocate some big object on the heap (e.g. some intermittent helper collection), and then reference it from a lambda, that big object will continue to live and will never get garbage collected for as long as there is a single lambda preserving the closure object in which it is stored.

Therefore, to prevent a memory leak and ensure that any temporary objects we allocate get garbage collected, if they are referenced in any lambdas, then once we are done with using those objects, we should explicitly de-reference them from the variables that point to them. For example:
```c#
var tempList = new List<string>(5000);
int count = 0;

Action DoSomethingWithList = () =>
{
    tempList.Add("Hello");
    // do something...
};

Func<bool> Increment = () =>
{
    bool ret = false;
    count++;
    // do something...
    return ret;
};

DoSomethingWithList();
vars.Increment = Increment;
```
When the code block containing this code finishes, the global `vars` variable retains a reference to the `Increment` function via the `vars.Increment` field.

Here, the `Increment` function captures the variable `count`, and thus a closure is created, so `count` lives in the heap-allocated closure object and not on the stack. Likewise, `DoSomethingWithList` captures the variable `tempList`, and so `tempList` also does not live on the stack but instead on the heap, in the same closure object as `count`.

When the code block containing this code finishes, the global `vars` variable retains a reference to the `Increment` function, which has a reference to the closure where `count` and `tempList` live, and therefore `tempList` cannot be automatically freed (garbage collected). This is a memory leak: that array of size 5000 will never be freed, and that memory is lost for the lifetime of the script. Although this may not be a big deal to do once, it is bad practice and if done many times, it can add up.

The good news is that although this all may seem complicated, the solution is incredibly simple. If there is a collection that is captured by a lambda that is no longer needed when the code block finishes executing, simply de-reference it. That is, once we are no longer using `tempList`, all we have to do is include the following line:
```c#
tempList = null;
```
Now, the `tempList` variable no longer references the actual list object that lives on the heap, thus that object no longer has a single reference, and the runtime will automatically free it during its garbage collection routine.

So, if we have any large temporary collections that are no longer needed after their temporary usage, we should de-reference them once we are done using them.
### Which Block?
When we create a lambda function and assign it to a variable, we are performing a heap allocation every time. And if the function captures some variable, then we are also performing an extra heap allocation for the required closure (though this is only done once per code block if the lambdas are created on the outer layer of the code block, i.e. not in a code block within a code block, in which case an extra closure for the nested code block may be created).

Therefore, to avoid huge performance losses, lambda functions should be defined in a code block that runs rarely, and ideally just once. Likewise, to avoid performance losses by having to traverse the incredibly slow `vars` `ExpandoObject` every time we want to call a function, ideally most of our functions that are on a hot path should not be behind the `vars` variable.

The only way this is possible is if all or almost all of our core logic is defined in one single code block that runs rarely or once, and then use the `vars` variable only to add entry points to the core logic from the other code blocks.

The most obvious candidate for this is the `startup` block, which only runs once in the lifetime of the script. The `init` block is a close second, however it is not ideal to place heavy initialisations there as it runs every time the game process restarts, so ideally it should be `startup` which truly only runs once.

So, we can define any functions and variables that our core logic requires at the top of our `startup` block, avoiding the `vars` variable as much as we can. The advantage of this is threefold:
1. Every variable and function access is much faster when it is accessed directly from the same `startup` block rather than from the dynamic `vars` object. Also, not relying on dynamic objects allows the compiler to better predict what will happen and perform all sorts of optimisations. At 60 or so iterations per second, this matters.
2. The code looks better and is much more readable, because it just becomes standard C# (albeit a very old version). For example, when writing a split condition lambda into a statically typed variable, `new Func<bool>(() => vars.splitXyz(53f, 12f, 17f))` simply becomes `() => SplitXyz(53f, 12f, 17f)`. (Less verbose, fewer brackets.)
3. By avoiding the `vars` object and declaring all of our functions and variables in the `startup` block using native C# code, we gain the benefit of compile-time type safety. If we try to perform an invalid operation, the compiler will immediately warn us before the `startup` block even runs, as opposed to having to physically run literally every single code path to ensure none of them have an invalid variable access or some such. (For example, suppose we have a `Dictionary<string, Tuple<...>>` variable. If we place this dictionary behind the `vars` object, then writing literally any valid C# syntax will compile, e.g. `int val = vars.dict[17].Item4[vars.indexx];`. We will not find out that we tried to index a string dictionary with an integer, that perhaps we accessed the wrong tuple item, or that we accidentally added an extra "x" to `vars.index` until we actually run the exact code path that contains this line. If we have many such lines that are on distinct code paths, it could be a nightmare to test all of them. Avoiding the `vars` variable gives us compile-time safety so that the compiler can warn us of such trivial errors before the code even runs.)

Therefore, startup logic and any methods needed for startup logic can simply be embedded directly in the `startup` block without using the `vars` variable at all. Then, instead of having our whole core logic travel back and forth between blocks and across the `vars` variable, we can instead transfer the minimal amount of data via the `vars` variable. For example, rather than having the core update logic inside the `update` block and then slowly calling a bunch of functions and fetching a bunch of variables from behind the `vars` variable 60 times per second, we can instead write the following code:
```c#
startup
{
    // ... core startup logic ...

    Func<bool> Update = () =>
    {
        bool ret = false;
        // ... core update logic ...
        // from here we have access to all variables and functions
        //      natively declared in the startup block, with type safety
        return ret;
    };
    vars.Update = Update;
}

update
{
    return vars.Update();
}
```
And likewise we can create similar entry points for all the other code blocks, unless those code blocks' core logic is so simple that going into `startup` is simply not needed (for example setting the `version` action variable from the `init` block, which can be done independently without accessing any data from `startup`).
### Action Variables
As mentioned previously, ASL action variables are not global but rather each code block receives them as new local variables each time it is executed.

This creates a problem, because if all of our core logic is in the `startup` block, then all of our core logic will rely on the local action variables that were given at startup, so if the global action variables that are stored in LiveSplit's backend have since changed, these changes will not be reflected in the local action variables of the `startup` block. For example, the `old` and `current` variables simply have values of `null` at the beginning of the `startup` block, so if our core logic in the `startup` block consists of functions that rely on these variables, then those functions will capture the local variables from `startup` which have values of `null` and will continue to have values of `null` for the lifetime of the script, unless they are explicitly overwritten. Likewise, the `settings` variable will contain a pointer to the settings builder object, whereas eventually we need to access the settings reader object, but the `settings` variable in the `startup` block will continue to point to the settings builder object for the lifetime of the script, unless it is explicitly overwritten.

So, we can simply overwrite those action variables that we need once we get the real values from other code blocks. Most action variables already point to their correct objects by the time the `init` block is invoked, so we can pass most variables from the `init` block, which only has to be done once whenever the game process is started/restarted.

Indeed, this is true of the `current` and `settings` variables: these local action variables in the `init` block already point to the global respective objects that will be relevant for the lifetime of the game process. So we can simply transfer those objects once every game start from the `init` block to the `startup` block.

The only object that actually needs to be passed each cycle is the object containing the "old" state, since for some reason LiveSplit creates a new object for that each cycle. (One may wonder why they couldn't have simply overwritten the data in the existing "old" object each cycle as they do with the "current" object, but alas, the one who wonders this is also probably not the one who wrote LiveSplit.) In the `startup` block the `old` variable initially points to `null` and in the `init` block it initially points to the same object as the `current` variable - that is, the global "current" object. This is why if we try to put functions that capture these variables (without explicitly overwriting them) in the `startup` block we get null reference exceptions, and if we put them in the `init` block we get the `old` variable pointing to the "current" object.

Therefore overall, this is how we can lay out our script (many code blocks are omitted for brevity):
```c#
startup
{
    // ... function declarations and data initialisations ...
    // ... configuration of settings and events ...
    // ... core startup logic ...
    
    Action<ExpandoObject, ExpandoObject, object> Init = (newOld, newCurrent, newSettings) =>
    {
        old = newOld;
        current = newCurrent;
        settings = newSettings;
        // pass and assign any other required action variables here

        // ... core init logic ...
    };

    Func<ExpandoObject, bool> Update = newOld =>
    {
        old = newOld;

        bool ret = false;
        // ... core update logic ...
        return ret;
    };

    Action OnStart = () =>
    {
        // ... core onStart logic ...
    };

    Func<bool> Start = () =>
    {
        bool ret = false;
        // ... core start logic ...
        return ret;
    };

    Func<TimeSpan> GameTime = () =>
    {
        TimeSpan ret = TimeSpan.Zero;
        // ... core gameTime logic ...
        return ret;
    };

    vars.Init = Init;
    vars.Update = Update;
    vars.OnStart = OnStart;
    vars.Start = Start;
    vars.GameTime = GameTime;
}

init
{
    // ... basic init logic ...

    vars.Init(old, current, settings);
}

update
{
    return vars.Update(old);
}

onStart
{
    vars.OnStart();
}

start
{
    return vars.Start();
}

gameTime
{
    return vars.GameTime();
}
```
And from here on we can trivially write our entire core logic entirely in the `startup` block without having to fetch anything else from the dynamic `vars` `ExpandoObject`. We can refer to the `old`, `current`, and `settings` variables directly from the `startup` block and it will work seamlessly, since the `init` and `update` blocks pass them as required.

So, on each cycle, instead of moving ***everything*** through the global `vars` variable from all over the place, we move just the `old` variable to the `startup` block and that's it, and everything else is already there locally.

See an example of all of this implemented in the [Prince of Persia 2008](pop_2008.asl) script.
## Records, Structs, and Tuples
### Tuple Basics
Unfortunately ASL does not support custom records or structs. However, it does support tuples which can work as alternatives for records and structs, though they are a bit cumbersome to use.

Unfortunately, the notation where we specify a tuple type by simply writing its constituent types in brackets (e.g. `(int, int, bool)`) does not compile in ASL, and likewise instantiating a tuple by merely writing the constituent values in brackets (e.g. `(5, 3, false)`) does not work either. Instead, we must specify the type explicitly as `Tuple<T...>` or `ValueTuple<T...>`, where `Tuple` represents a reference tuple and `ValueTuple` represents a value tuple. Then, we can instantiate values of these types by using the `Tuple.Create` and `ValueTuple.Create` methods. For example:
```c#
Tuple<string, int, int> myTuple = Tuple.Create("Hello, World!", 17, 19);
ValueTuple<int, string, bool> myValueTuple = ValueTuple.Create(5, "Goodbye", false);
```
Then we can access each item of our tuple by writing `tuple.Item1`, `tuple.Item2`, etc. We can read the items from any tuple, though we can only write items to value tuples since reference tuples are read-only, as shown:
```c#
string helloString = myTuple.Item1;
bool condition = myValueTuple.Item3;

myValueTuple.Item2 = "Bye";

// this line does not compile since reference tuples are read-only
// myTuple.Item3 = 7;
```
### Reference Tuple vs. Value Tuple
A reference tuple behaves similarly to a C# `record class`, as each has the following features:
- is passed by reference
- provides equality comparison by constituents
- is read-only

Likewise, a value tuple behaves similarly to a C# `record struct`, as each has the following features:
- is passed by value
- provides equality comparison by constituents
- is mutable

**The default tuple type in vanilla C# when we declare a tuple using brackets - e.g. `(int, int) tuple = (5, 3);` - is a value tuple `ValueTuple`.**

A reference tuple should be chosen if we do not intend to mutate our data after creating the tuple, and if we have a lot of data or need to refer to the same data from many locations, thus putting the data behind a reference makes sense so that the program only ever has to copy a reference to the data and not the data itself.

On the other hand, a value tuple should be chosen if the data needs to be mutated or if the data is small and won't be copied a lot. Remember that creating a reference tuple requires allocating space on the heap, traversing a pointer every time we want to use the data, and finally letting the garbage collector free the memory again once we stop using the tuple. If this sounds like overkill, then stick with a value tuple, which is functionally exactly the same as simply declaring multiple values one after the other.
### Nullable Types
Remember also that all reference type variables can by default hold a value of `null` (meaning that it contains the null pointer - it points to nothing), however value type variables hold the value directly so they cannot have a value of `null`. However, if we do nonetheless want a variable to hold a value directly without having to allocate space on the heap while allowing for a `null` value, then we can simply declare a nullable type by appending a `?` to the type name. For example, continuing with the variables from before:
```c#
myTuple = null; // allowed since Tuple is a reference type
helloString = null; // allowed since string is a reference type

// this does not compile since a value type variable cannot hold a value of null
// myValueTuple = null;
// condition = null;

ValueTuple<int, int?, bool>? nullableValueTuple = ValueTuple.Create(5, (int?)null, false);
float? nullableFloat = 7f;
float myFloat = (float)nullableFloat; // float? to float requires explicit cast
float myFloat2 = nullableFloat.Value; // another way of writing the same thing

nullableFloat = null;
nullableValueTuple = null;
```
### Equality Comparisons
If tuples need to be compared for equality, the best way is to use the built-in `Equals` method which checks for the equality of each constituent of the tuple. Be careful though, because for reference tuples the `==` operator compares the references of the two tuples, and not the constituent values. As for value tuples, the `==` operator does not compile at all. This is illustrated in the following example:
```c#
Tuple<int, int, int> t1 = Tuple.Create(5, 5, 3);
Tuple<int, int, int> t2 = Tuple.Create(5, 5, 3);
Tuple<int, int, int> t3 = Tuple.Create(5, 5, 4);

// this operation copies the reference to the tuple stored in t1
Tuple<int, int, int> t4 = t1;

print((t1 == t2) + " " + (t1 == t3) + " " + (t1 == t4) +
    "\r\n" + t1.Equals(t2) + " " + t1.Equals(t3) + " " + t1.Equals(t4));

// Output:
// False False True
// True False True

ValueTuple<int, string, int> vt1 = ValueTuple.Create(5, "Hello", 3);
ValueTuple<int, string, int> vt2 = ValueTuple.Create(5, "Hello", 3);
ValueTuple<int, string, int> vt3 = ValueTuple.Create(5, "hello", 3);

// this operation copies the value 5, the reference to the string "Hello", and the value 3
ValueTuple<int, string, int> vt4 = vt1;

// print((vt1 == vt2) + " " + (vt1 == vt3) + " " + (vt1 == vt4)); // does not compile
print(vt1.Equals(vt2) + " " + vt1.Equals(vt3) + " " + vt1.Equals(vt4));

// Output:
// True False True
```
# Settings and Events
This section explains how settings and events are implemented in the [Prince of Persia 2008](pop_2008.asl) script and possibly some other scripts in the future.

We represent settings and events with reference data structures that look something like the following:
```c#
record Setting(bool Default, string Slug, List<string> EventSlugs, string Description, string? ToolTip, string? ParentSlug);
record Event(int EventType, string Slug, List<string> SettingSlugs, (float, float, float, float, float, float)? XyzBounds, Func<bool> Condition);
```
But since records aren't available in ASL, we instead write the equivalent tuples:
```c#
Tuple<bool, string, List<string>, string, string, string> setting;
Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>> @event;
```
Ideally `EventType` should be an enum, but we cannot create custom enums in ASL, so instead we stick with an integer and then define constant values:
```c#
const int StartEvent = 0;
const int ResetEvent = 1;
const int SplitEvent = 2;
const int MiscEvent = 3;
```
Each setting has a list of events that it's tied to, and each event has a list of settings that it's tied to. However, when declaring our settings and events, this does not need to be explicitly specified both ways. So we may:
1. Specify which events are tied to each setting; or
2. Specify which settings are tied to each event; or
3. Do any combination of both, and the script will auto-fill the settings list for each event and the events list for each setting, removing any duplicates.

If we try to tie to a setting an event which is not defined, an exception will be thrown and startup will fail. Likewise if we try to tie to an event a setting which is not defined, an exception will be thrown.

After startup, all `Setting` objects get garbage collected and only `Event` objects remain.

For `Setting.EventSlugs` and `Event.SettingSlugs` we prefer a `List<string>` over a `HashSet<string>` because iterating over a list is faster. Since the user can technically change their settings at any time (even after the run starts), we have no choice but to check these settings in our `update`/`split` logic, and so a faster lookup is preferable. Therefore removing duplicates is a bit slower on startup, but this saves performance once the run actually starts.

If an event has no setting tied to it, then it succeeds upon meeting its condition (as long as it has not already been completed). On the other hand, if an event has one or more settings tied to it, then it succeeds upon meeting its condition if and only if at least one of its settings permits it (as long as it has not already been completed). Notably, even if an event does not succeed because its settings do not permit it, once its condition is met it is still considered completed and is stored in the `CompletedEvents` hashset.

***WARNING:*** Multiple uncompleted events must ***not*** have conditions that can possibly be met on the same cycle, as this will cause undefined behaviour. The script can only handle one uncompleted event with a successful condition on one cycle. The `update` logic checks if any uncompleted events meet their condition on that cycle, and as soon as it finds one such event, it stops looking, and so the other event will be ignored. Although at present the code will probably take the first event and ignore the second, this order should not be assumed. If multiple events with very similar conditions need to be specified, then the later events should explicitly check that the previous events have been completed (i.e. `CompletedEvents.Contains("Event1")`) as part of their condition. For example, this could be useful if two fights occur in the same area, so the first event can simply have a condition of finishing a fight in that area, and the second event can have a condition of the first even being complete and a fight being finished in that area.

***WARNING:*** If we forget to tie an event with a setting, the script will work normally, the setting will do nothing, and the event will always succeed regardless of the setting. To avoid forgetting to tie settings with events, when we make a change, we should open DebugView and review the printed settings, events, and statistics thereof to make sure they are correct.

When we specify settings, parent settings must be specified before their respective children settings (else an exception will be thrown on startup). Settings with the same parent (or lack of parent) will be displayed in the same order as defined in the `CONFIGURATION` section of the script.

`XyzBounds` is specific to the Prince of Persia 2008 script where we use the character's coordinates to create a hash value which allows for O(1) event lookups. (That is, an event's condition only needs to be evaluated when the character is near the event's location, rather than all events' conditions blindly being evaluated each cycle.) This could be useful for any 3D game where such location-based hashing is appropriate, but for other games alternative hash functions may be used and thus the `Event` data structure should change accordingly. That said, whatever values are used for the hash function, the field in `Event` representing the values to be hashed should be a nullable `ValueTuple` or some other nullable type, where a `null` value represents that that event cannot be hashed and needs to be checked each cycle regardless of current state. For more information, see the hashing section below.
# Hashing
This section explains how hashing is implemented in the [Prince of Persia 2008](pop_2008.asl) script and possibly some other scripts in the future.

In the past, on every single cycle, our script checked every single split's condition and if one of them came back `true` it split. Thus split lookup was O(`n`) where `n` is the total number of splits defined in the script. The new Prince of Persia 2008 script has O(`1`) split lookup, and executes each cycle about 2.5 times faster than the old script (though this number is very rough). (Rather, technically split lookup is now O(`l`) where `l` is the total number of splits in that immediate area, but most of the time `l=1`, occasionally goes up to `l=2`, very rarely `l=3`, and technically at the very start of the run `l=4` because there are two different start conditions and two different reset conditions in exactly the same place.) Notably, the script already runs faster, but it also now supports adding even hundreds of splits without slowing down whatsoever, unless all of those splits happen to be in exactly the same area.

## Startup and Runtime Computations
So, how exactly does our script know when we are near an event condition?

On each cycle, instead of blindly checking each event condition, we instead compute a hash value using our current `x`, `y`, and `z` coordinates. Informally, all points that are near each other yield the same hash code. Therefore, if we are in one place and move a little bit from that place, the hash value of our coordinates does not change. Therefore, for all events, if we know the location in which they occur, we can use the `Event.XyzBounds` field to pre-compute all possible coordinate hash values that overlap with the range of points that that event condition covers, and store them in a dictionary. Thus at startup we declare a variable called `XyzEventHashMap` of type `Dictionary<int, List<Event>>`, and then for every single event add all possible hash values that the event location can yield, and put the `Event` object behind that hash value in the dictionary. For the values we use a `List<Event>` because sometimes multiple events can be near each other, but most of the time that list has just one element.

Then, once the run starts, the `update` logic merely has to compute the hash value from the current `x`, `y`, and `z` coordinates and check if `XyzEventHashMap` contains that key, which is an O(`1`) operation. If it does not contain that key, then there is no event in that area, and so the `update` logic no longer has to check anything at all. On the other hand, if the key is found, then the list of events corresponding to the hash value are fetched, and each one is iterated over to check that the event is uncompleted and to check its condition.

## Hashing Algorithm
First, for each game we choose a bucket size, which is a `float` denoting a length in terms of the game's coordinate units:
```c#
const float BucketSize;
```

All real numbers are then broken down into equally sized buckets, based on `BucketSize`. For example, if `BucketSize = 20f`, then:
- `0f <= coord < 20f` falls into bucket `0`
- `20f <= coord < 40f` falls into bucket `1`
- `40f <= coord < 60f` falls into bucket `2`
- `-20f <= coord < 0f` falls into bucket `-1`
- `-40f <= coord < -20f` falls into bucket `-2`
- etc.

So all coordinates within the same bucket have the same hash code. Notably, if LiveSplit fails to dereference the coordinates because they are not behind valid pointers (e.g. if we are in the main menu), then it just gives us the default values, thus the script will perceive each coordinate to be `0f` in that case, and so that coordinate will fall into bucket `0`. Likewise, coordinate values of `NaN`, `∞`, and `-∞` will also fall into bucket `0`.

To determine which bucket a single coordinate falls into, we use this very simple algorithm:
```c#
Func<float, int> GetCoordHashCode = coord => (int)Math.Floor(coord / BucketSize);
```
Then we implement a fast hash-combination algorithm with wide dispersion where the same inputs ordered differently yield different results. Thus we can compute which 1D bucket each of our `x`, `y`, and `z` coordinates falls into, and then hash those 1D bucket values together to get an unpredictable yet deterministic 3D bucket hash.

Therefore, the whole world is split into equally sized 3D bucket cubes, and every single point in 3D space falls into a cube of length `BucketSize`. Then, all coordinates within the same bucket have the same hash code.

Finally, at startup we populate `XyzEventHashMap`. We take `Event.XyzBounds` to be a cuboid which encompasses every possible point in which that event could occur (and possibly some points where the event doesn't occur). Then, we find all buckets containing points within the cuboid specified by `Event.XyzBounds`, and compute their hash codes. Then we simply add each of those hash codes to `XyzEventHashMap`, along with the event from which we got the cuboid bounds.

Then at runtime during each cycle we hash the player's coordinates and compare this against the hash codes contained in `XyzEventHashMap` to find which events overlap with the current bucket that the player is in. For each event that overlaps with the current bucket that the player is in, we check that it has not been completed and check its condition, and then start/split/reset (or do nothing if it's a misc event) accordingly.
## `BucketSize` Choice
For each game we must choose an appropriate bucket size.

If `BucketSize` is significantly smaller than the lengths of a given event's cuboid, then the number of buckets that overlap with that event will be massive, and thus the size of the `XyzEventHashMap` dictionary will be very large, since it grows cubically. So to avoid having to store extremely large arrays in memory, `BucketSize` should not be smaller than the largest expected cuboid length by more than an order of magnitude or so. On the other hand, if `BucketSize` is so large that many event cuboids are found in the same bucket, then we lose the benefit of this whole hashing algorithm as we end up having to check many event conditions on each cycle anyway.

So for each game an appropriate bucket size should be chosen to get the best mix of saving memory and increasing performance. The choice for this value is not very precise, but there is effectively a "correct" order of magnitude to choose. For example, a bucket size of `0.1f` for Prince of Persia 2008 will cause the `XyzEventHashMap` dictionary to expand so much that LiveSplit will literally end up occupying several gigabytes of memory, and our PC fans will go crazy. On the other hand, a bucket size of `1000f` will put almost all splits in the same bucket, so the benefit of hashing is lost. For Prince of Persia 2008 we choose a bucket size of `20f`, but realistically anything from `10f` to about `150f` would be fine.

To help make the decision, once startup is complete the size of `XyzEventHashMap` is printed and can be viewed with DebugView. We should multiply this number by about 50-100 to get a ballpark estimate of the number of bytes it is occupying in memory. Likewise the exact distribution of buckets that contain event collisions is also printed after startup. Therefore we can trivially change the bucket size and within seconds see how this will affect memory and performance, and base our decision for the bucket size on that.

(If the debug output is too spammy, we can increase the `MinEventCountPerBucketToCompute` constant until it is sufficiently terse.)