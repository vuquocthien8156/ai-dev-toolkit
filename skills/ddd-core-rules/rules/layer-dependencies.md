# Layer Dependencies

The fundamental rule of DDD is the Dependency Inversion Principle applied to layers: outer layers depend on inner layers. The inner-most layer (Domain) depends on nothing.

```
Domain ← Application ← Infrastructure ← Presentation
```

## 1. Domain Layer

- **Responsibility**: Heart of the software. Business rules, state, and facts.
- **Allowed Imports**: `src/common` (pure JS/TS utils only).
- **FORBIDDEN Imports**:
  - Framework (NestJS `@nestjs/*`, Express, Spring)
  - ORM (TypeORM, Prisma, Sequelize)
  - External services (Stripe API, AWS SDK)
  - Any other layer (`application`, `infrastructure`, `presentation`)

## 2. Application Layer

- **Responsibility**: Orchestrates domain logic via Use Cases / Command Handlers.
- **Rules**:
  - Each Use Case should ideally have a single `execute()` method.
  - Depends on domain interfaces (Ports), never on concrete infrastructure implementations.
- **Allowed Imports**: `domain` layer.
- **FORBIDDEN Imports**: `infrastructure`, `presentation` layers.

## 3. Infrastructure Layer

- **Responsibility**: Implements domain Ports. Database, APIs, Emails.
- **Rules**:
  - Contains ORM entities (often separate from Domain Entities).
  - Handles serialization/deserialization between domain and persistence formats (Mappers).
- **Allowed Imports**: `application` (ports), `domain`.

## 4. Presentation Layer

- **Responsibility**: HTTP controllers, GraphQL resolvers, CLI handlers, Consumers.
- **Rules**:
  - Thin layer — only routing + validation + DTO mapping.
  - Never contains business logic.
- **Allowed Imports**: `application` (commands/queries), `domain` (types/enums only, rarely logic).
