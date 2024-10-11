using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Linq;

namespace ASLSyntaxChecker
{
    public class ASLSyntaxChecker
    {
        private static readonly Regex MethodRegex = new Regex(
            @"(?<name>init|isLoading|reset|start|split|startup|shutdown|exit|update|onStart|onSplit|onReset)\s*{\s*(?<body>(?:[^{}]*|\{(?<depth>)|}(?<-depth>))*(?(depth)(?!)))}",
            RegexOptions.Compiled | RegexOptions.Singleline | RegexOptions.IgnorePatternWhitespace);

        public static void CheckSyntax(string scriptPath)
        {
            Console.WriteLine($"Checking script '{scriptPath}'");
            var scriptContent = File.ReadAllText(scriptPath);
            var methodMatches = MethodRegex.Matches(scriptContent);
            bool errorsFound = false;

            foreach (Match match in methodMatches)
            {
                string methodName = match.Groups["name"].Value;
                string methodBody = match.Groups["body"].Value;

                if (!string.IsNullOrWhiteSpace(methodBody))
                {
                    var syntaxTree = CSharpSyntaxTree.ParseText(methodBody);
                    var diagnostics = syntaxTree.GetDiagnostics();

                    if (diagnostics.Any(d => d.Severity == DiagnosticSeverity.Error))
                    {
                        errorsFound = true;
                        Console.WriteLine($"Syntax errors found in method '{methodName}'.");
                        foreach (var diagnostic in diagnostics)
                        {
                            Console.WriteLine($"- {diagnostic.GetMessage()} (Line: {diagnostic.Location.GetLineSpan().StartLinePosition.Line + 1})");
                        }
                    }
                    else
                    {
                        Console.WriteLine($"No syntax errors found in method '{methodName}'.");
                    }
                }
            }

            if (errorsFound)
            {
                throw new InvalidOperationException($"Syntax error(s) found in script {scriptPath}");
            }
        }

        public static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                throw new ArgumentException("No files provided.");
            }

            string scriptPath = args[0];
            CheckSyntax(scriptPath);
        }
    }
}
