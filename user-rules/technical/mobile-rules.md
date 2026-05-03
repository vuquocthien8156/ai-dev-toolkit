# MOBILE SPECIFIC RULES (Expo / React Native)

> [!IMPORTANT]
> Proactively load these technical skills from `~/.agents/skills/` when the context matches:
>
> | Trigger | Skill to Load |
> |---------|---------------|
> | Writing or reviewing React Native/Expo | `vercel-react-native-skills` |
| Upgrading Expo version or dependencies | `upgrading-expo` |
| EAS Build, Submit, or Deployment tasks | `expo-deployment` |

## Build & Configuration

- Always prioritize Expo workflows and EAS (Expo Application Services) build configurations.
- Avoid legacy React Native CLI linking or configurations unless explicitly necessary.

## Performance & Native Modules

- Be mindful of background processes (like background geolocation). Ensure listeners are properly cleaned up to prevent memory leaks.
- When styling, utilize the established design system rather than hardcoding values.
