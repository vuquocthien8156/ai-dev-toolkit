---
name: typescript-mastery
description: >
  Advanced TypeScript patterns for production codebases. Strict typing, generics,
  utility types, type guards, discriminated unions, branded types, and common pitfalls.
---

# TypeScript Mastery

> [!IMPORTANT]
> **MANDATORY**: These rules must be strictly followed for all TypeScript projects. This skill replaces the global Section III rules.

## Core Principles

1. **No `any`** — ever. Use `unknown` + type guards when type is truly unknown.
2. **Explicit return types** on all exported functions and methods.
3. **Prefer `interface`** for object shapes, `type` for unions/intersections.
4. **Use `readonly`** for data that should not change after creation.
5. **Naming**: PascalCase for classes/interfaces/types, camelCase for variables/methods, kebab-case for files.
6. **Functions**: single purpose, <20 lines, verb-first naming (`getUser`, `isValid`).
7. **RO-RO pattern**: Use Receive-Object-Return-Object for 3+ parameters.
8. **DTOs**: validate inputs (e.g., `class-validator`). Declare simple types for outputs.
9. **Prefer composition** over inheritance. Follow SOLID principles.
10. **Use `as const`** for literals, `readonly` arrays/tuples where applicable.

## Type Design

### Prefer `interface` for Object Shapes

```typescript
// ✅ Good — extendable, clear intent
interface UserProfile {
  readonly id: string;
  name: string;
  email: string;
}

// ✅ Good — `type` for unions and intersections
type PaymentStatus = "pending" | "completed" | "failed";
type AdminUser = UserProfile & { role: "admin" };
```

### Discriminated Unions for State

```typescript
// ✅ Use discriminated unions — exhaustive checking
type AsyncState<T> =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: T }
  | { status: "error"; error: Error };
```

### Branded Types for Domain Safety

```typescript
type UserId = string & { readonly __brand: 'UserId' };
type OrderId = string & { readonly __brand: 'OrderId' };

// Prevents accidental swapping of userId and orderId
function getOrder(userId: UserId, orderId: OrderId): Order { ... }
```

## Type Guards

```typescript
// ✅ Custom type guard
function isUser(value: unknown): value is User {
  return (
    typeof value === "object" &&
    value !== null &&
    "id" in value &&
    "email" in value
  );
}

// ✅ Discriminated union guard
function isSuccess<T>(
  state: AsyncState<T>,
): state is { status: "success"; data: T } {
  return state.status === "success";
}
```

## Immutability

```typescript
// ✅ Readonly for data that shouldn't change
interface Config {
  readonly apiUrl: string;
  readonly timeout: number;
}

// ✅ as const for literal values
const ROLES = ['admin', 'user', 'guest'] as const;
type Role = (typeof ROLES)[number]; // 'admin' | 'user' | 'guest'

// ✅ Readonly arrays and tuples
function processItems(items: readonly Item[]): void { ... }
```

## Generics

```typescript
// ✅ Constrained generics
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}

// ✅ Generic with default
interface Repository<T extends BaseEntity = BaseEntity> {
  findById(id: string): Promise<T | null>;
  save(entity: T): Promise<T>;
}

// ✅ Utility type composition
type PartialBy<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>;
```

## Function Patterns

```typescript
// ✅ RO-RO (Receive Object, Return Object) for 3+ params
interface CreateUserParams {
  readonly name: string;
  readonly email: string;
  readonly role?: Role;
}

interface CreateUserResult {
  readonly user: User;
  readonly token: string;
}

function createUser(params: CreateUserParams): CreateUserResult { ... }

// ✅ Overloads for different return types
function parse(input: string): number;
function parse(input: string, asArray: true): number[];
function parse(input: string, asArray?: boolean): number | number[] { ... }
```

## Common Pitfalls

### ❌ Don't

```typescript
// ❌ Using `any`
function process(data: any) { ... }

// ❌ Type assertion without validation
const user = data as User;

// ❌ Optional chaining without null handling
const name = user?.profile?.name; // name is string | undefined — handle it

// ❌ Enum (prefer union types or const objects)
enum Status { Active, Inactive }
```

### ✅ Do Instead

```typescript
// ✅ Type guard + unknown
function process(data: unknown): ProcessedResult {
  if (!isValidInput(data)) throw new InvalidInputError(data);
  return transform(data);
}

// ✅ Runtime validation before assertion
const user = validateUser(data); // throws if invalid

// ✅ Handle undefined explicitly
const name = user?.profile?.name ?? "Anonymous";

// ✅ Const object instead of enum
const Status = { Active: "active", Inactive: "inactive" } as const;
type Status = (typeof Status)[keyof typeof Status];
```

## Naming Conventions

| Type                         | Convention                 | Example                                   |
| ---------------------------- | -------------------------- | ----------------------------------------- |
| Class / Interface / Type     | PascalCase                 | `UserProfile`, `IRepository`              |
| Variable / Function / Method | camelCase                  | `getUserById`, `isValid`                  |
| File / Directory             | kebab-case                 | `user-profile.ts`, `auth-service.ts`      |
| Constant                     | UPPER_SNAKE_CASE           | `MAX_RETRIES`, `API_URL`                  |
| Boolean variable             | `is/has/can/should` prefix | `isLoading`, `hasPermission`              |
| Function                     | verb-first                 | `getUser`, `createOrder`, `validateInput` |
