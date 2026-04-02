---
description: Review C# code for quality, performance, and security issues
argument-hint: <file or branch>
---

# C# Code Review

Analyze the following C# code for:

## Code Quality
1. **SOLID Principles** - Check for Single Responsibility, Open/Closed, etc.
2. **Null Safety** - Are nullable reference types handled correctly?
3. **Async/Await** - No `.Result`, `.Wait()`, or blocking calls?
4. **Error Handling** - Specific exception catching? Proper logging?
5. **Naming** - PascalCase for public members, camelCase for locals?

## Performance Issues
1. **N+1 Queries** - Missing `.Include()` on EF Core queries?
2. **Unnecessary Allocations** - String concatenation loops? Boxing?
3. **Lazy Loading** - Should queries be eager loaded?
4. **Collection Operations** - Using LINQ inefficiently?

## Security
1. **Input Validation** - All user inputs validated?
2. **SQL Injection** - Using parameterized queries / EF Core?
3. **Authorization** - Endpoints properly protected?
4. **Secrets** - No API keys, passwords in code?
5. **Logging** - No sensitive data in logs?

## Code Structure
1. **Class Cohesion** - Does each class have one reason to change?
2. **Dependencies** - Properly injected, not created with `new`?
3. **Testing** - Code is testable? Dependencies mockable?
4. **Magic Numbers** - Constants defined, not hardcoded?

## Specific .NET Checks
- Using `record` for immutable DTOs?
- Using `required` keyword for mandatory properties?
- Using `IAsyncEnumerable` for streaming results?
- Using `ConfigureAwait(false)` in libraries?
- Proper use of `IDisposable` / `IAsyncDisposable`?

Provide:
1. **Issues Found** - specific line numbers and severity (Critical/High/Medium/Low)
2. **Code Examples** - show before/after for major issues
3. **Performance Impact** - estimate if applicable
4. **Suggested Fix** - concrete C# code to resolve