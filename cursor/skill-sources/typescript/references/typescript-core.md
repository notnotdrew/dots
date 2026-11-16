# TypeScript Core Reference

Load this only for a generics, narrowing, or type-level question the skill rules do not settle.

## Illegal states

A union takes away impossible combinations. Flags and optionals add them.

```typescript
type User =
  | { isLoggedIn: false }
  | { isLoggedIn: true; username: string };
```

## Narrowing

Discriminants and control flow replace `as` and `!`.

```typescript
type Result<T> =
  | { status: 'success'; data: T }
  | { status: 'error'; error: Error };

function valueOf<T>(result: Result<T>): T {
  if (result.status === 'error') throw result.error;
  return result.data;
}
```

## Inference without extra annotations

`satisfies` checks a value against a type without widening it. `as const` keeps literals. Use them instead of annotating a variable and then fighting the widened type.

```typescript
const routes = ['/home', '/users'] as const;
const user = { id: '1', role: 'admin' } satisfies {
  id: string;
  role: 'admin' | 'user';
};
```

## Unions over enums

A string union adds no runtime. An `enum` adds an object. Prefer the union unless the repo already uses enums.

```typescript
type Status = 'pending' | 'approved' | 'rejected';
```

## When a generic stays

A generic stays when the output is a function of the input and more than one caller needs that relationship. `getProperty` earns `K extends keyof T` because `T[K]` is a fact a concrete type cannot show.

```typescript
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}
```

A generic with one instantiation is a concrete type. Mapped types, conditionals, brands, and utility-type composition stay out until a named type is materially worse.
