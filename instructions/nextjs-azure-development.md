# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Development
- `npm install` - Install dependencies
- `npm run dev` - Start development server (http://localhost:3000)
- `npm run build` - Build static export for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint with Next.js core-web-vitals config

### Testing
No test framework is currently configured in this project.

## Architecture Overview

This is a **Next.js 15.3.3** application using the **App Router** (`/app` directory) for Garcia Family Medicine's website. The application is configured for **static export** (`output: 'export'`) targeting Azure Static Web Apps deployment.

### Key Technologies
- **Framework**: Next.js 15.3.3 with App Router
- **Styling**: Tailwind CSS v3.4.10 + CSS Modules hybrid approach
- **UI Components**: React 19 with React Icons and Lucide React
- **Email Integration**: Power Automate webhooks with SharePoint backend
- **Deployment**: Azure Static Web Apps with static export
- **Icons**: Lucide React, React Icons (Font Awesome)

### Project Structure
```
app/                        # Next.js App Router pages
├── globals.css            # Global styles with Tailwind imports
├── layout.js              # Root layout with font loading and smooth scroll
├── page.jsx               # Homepage with carousel
├── news/                  # Blog system (main listing and individual posts)
│   ├── page.jsx           # Blog listing with category filtering
│   └── [slug]/            # Dynamic blog post pages
├── care/                  # Specialized care service pages
├── contact/               # Contact page
├── events/                # Event pages (current, past, specific events)
├── meetthedoctor/         # Doctor biography page
└── services/              # Service pages (CoreLift, CareCredit, etc.)

components/                 # Reusable React components
├── header/                # Navigation header with dropdowns and mobile menu
├── footer/                # Footer with comprehensive CTA and partner logos
├── calendar/              # Event calendar system
├── blog/                  # Blog data management and utilities
└── emailsubscription/     # Email subscription component with analytics

public/images/             # Static assets organized by section
```

### Styling Architecture
- **Global styles**: `app/globals.css` with Tailwind directives and CSS custom properties
- **CSS Modules**: Component-specific styles (e.g., `header.module.css`, `mobile.module.css`)
- **Tailwind config**: Custom mobile breakpoints (max: 768px), colors using CSS variables, and typography plugin
- **Font loading**: Sumana font via Next.js Google Fonts with CSS variables
- **Responsive design**: Mobile-first with separate mobile stylesheets for complex components

### Component Patterns
- **Client components**: Most components use `'use client'` directive for interactivity
- **Mobile-first responsive**: Custom mobile breakpoint (max: 768px) with separate mobile stylesheets
- **State management**: React hooks (useState, useEffect, useRef) for local component state
- **Navigation**: Complex header with dropdown menus, flyouts, and mobile hamburger menu

### Data Management
- **Static data**: Navigation links (`components/header/navdata.js`) and calendar events stored in JavaScript modules
- **No backend**: Static site with no API routes or server-side functionality (API routes exist but are placeholders)
- **Event system**: Calendar events managed via `components/calendar/calendar-events.js` with recurring event support
- **Blog system**: Static blog posts managed via `components/blog/blog-data.js` with filtering and navigation
- **Email collection**: Client-side email signup with Power Automate webhook integration and localStorage fallback

## Development Notes

### Known Issues
- **CSS Modules + Tailwind**: Careful management needed to avoid style conflicts
- **Mobile navigation**: Complex state management for responsive menu behaviors
- **Static export**: Images must use `unoptimized: true` in next.config.mjs

### Performance Optimizations
- Webpack bundle splitting configured for vendor and common chunks
- Console logs removed in production builds
- Font loading optimized with `display: 'swap'`
- Smooth scrolling utility for hash navigation
- Image optimization with WebP format and JPEG fallback using Picture component

### File Naming Conventions
- **STRICT RULE**: ALL files and directories MUST use lowercase naming only
- **Pages**: `page.jsx` (App Router convention)
- **Layouts**: `layout.js`
- **Components**: `componentname.jsx` (lowercase only)
- **Directories**: `emailsubscription`, `smoothscroll` (lowercase only, no capitals)
- **Styles**: `componentname.module.css` for CSS Modules, `mobile.module.css` for mobile-specific styles
- **Utilities**: lowercase with hyphens (e.g., `smooth-scroll.js`)
- **Documentation**: `readme.md`, `changelog.md`, `claude.md` (lowercase only)

### Content Organization
- **Healthcare pages**: Organized by service type (`/care`, `/services`)
- **Events**: Temporal organization (`/events/current`, `/events/past`)
- **Blog/News**: Integrated blog system at `/news` with dynamic content in navigation
- **Images**: Structured by page/section in `/public/images`
- **Mobile styles**: Separate stylesheets for mobile-specific styling

## Critical Configuration

### GitHub Secrets Required for Production
- `NEXT_PUBLIC_NEWSLETTER_WEBHOOK_URL`
- `NEXT_PUBLIC_NEWSLETTER_ENABLED`
- `NEXT_PUBLIC_NEWSLETTER_SUCCESS_MESSAGE`
- `NEXT_PUBLIC_NEWSLETTER_ERROR_MESSAGE`

Without these, email subscriptions fall back to localStorage only.

### Environment Variables
- `.env.local` - Local development configuration
- All NEXT_PUBLIC_ variables are exposed to the client-side
- Webhook URL points to Power Automate flow for SharePoint integration
- Default fallback values configured in `next.config.mjs`

## Documentation Standards

### CHANGELOG.md Requirements
- **Location**: Root directory (NOT in docs/) - industry standard
- **Format**: Chronological order with NEWEST entries first
- **Structure**: `## [Version] - YYYY-MM-DD` with Added/Fixed/Changed/Removed subsections
- **Versioning**: Semantic versioning (MAJOR.MINOR.PATCH)
- **Updates**: MUST be updated before every deployment for significant changes

### Documentation Workflow
- Always update CHANGELOG.md for feat:, fix:, and breaking changes
- Use chronological order: newest versions at top
- Group changes within versions by type (Added/Fixed/Changed/Removed)
- Keep changes concise and user-focused

### Important Instructions
- NEVER create files unless absolutely necessary for achieving goals
- ALWAYS prefer editing existing files over creating new ones
- Documentation files should only be created when explicitly requested
- CHANGELOG.md is critical and must be maintained for all significant changes

## Power Automate Integration

### Working Email Integration
- **Azure CLI + Power Automate API**: Successfully creates flows programmatically
- **Webhook Integration**: Website forms submit to Power Automate webhooks
- **SharePoint Backend**: Email subscriptions saved to SharePoint list with 20+ analytics fields
- **OAuth Limitation**: SharePoint connections require manual authorization in Power Automate UI

### Email Subscription Analytics
The email subscription component collects comprehensive analytics including:
- Device information (platform, browser, screen resolution)
- Geographic data (timezone, language)
- User behavior (referrer, viewport size)
- Connection details (network type, mobile/tablet detection)

For detailed Power Automate integration steps, see the [GitHub Wiki](https://github.com/GarciaFamilyMedicine/garciafamilymedicine.care/wiki/Power-Automate-SharePoint-Integration).

## Security Best Practices

- Never commit sensitive IDs, webhooks, or credentials
- Use placeholder values in documentation
- Store production secrets in GitHub Secrets
- Sanitize all documentation before commits
- Use .gitignore patterns for sensitive files