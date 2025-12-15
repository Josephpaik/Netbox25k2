# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About NetBox

NetBox is a Django-based web application for network infrastructure management (IPAM/DCIM). It serves as the source of truth for network infrastructure, providing a comprehensive and inter-linked data model for network primitives like devices, racks, cables, IP addresses, VLANs, circuits, power distribution, VPNs, and more.

**Tech Stack**: Python 3.10+, Django 5.2, PostgreSQL, Redis, Django REST Framework, Strawberry GraphQL, TypeScript, Vue.js

---

## Development Commands

### Initial Setup
```bash
# Install Python dependencies
pip install -r requirements.txt

# Copy and configure settings (edit with your SECRET_KEY, ALLOWED_HOSTS, DB, REDIS)
cp netbox/netbox/configuration_example.py netbox/netbox/configuration.py

# Run database migrations
python netbox/manage.py migrate

# Create superuser
python netbox/manage.py createsuperuser

# Collect static files
python netbox/manage.py collectstatic --no-input

# Run development server
python netbox/manage.py runserver
```

### Testing
```bash
# Run all tests
python netbox/manage.py test netbox/

# Run tests in parallel
python netbox/manage.py test netbox/ --parallel

# Run tests with coverage
coverage run --source="netbox/" netbox/manage.py test netbox/ --parallel
coverage report --skip-covered --omit '*/migrations/*,*/tests/*'

# Run tests for a specific app
python netbox/manage.py test netbox/ipam/tests/

# Run a single test file
python netbox/manage.py test netbox.ipam.tests.test_models

# Run a specific test class
python netbox/manage.py test netbox.ipam.tests.test_models.PrefixTestCase

# Run a specific test method
python netbox/manage.py test netbox.ipam.tests.test_models.PrefixTestCase.test_method_name
```

### Code Quality
```bash
# Run Python linting (PEP 8 compliance, line length 120)
ruff check netbox/

# Check for missing migrations
python netbox/manage.py makemigrations --check

# Frontend validation (ESLint, TypeScript, Prettier)
yarn --cwd netbox/project-static validate

# Verify static asset integrity
scripts/verify-bundles.sh
```

### Frontend Development
```bash
# Install frontend dependencies
yarn --cwd netbox/project-static install

# Build frontend assets
yarn --cwd netbox/project-static build

# Development mode with watch
yarn --cwd netbox/project-static dev
```

### Management Commands
```bash
# Interactive NetBox shell (like Django shell with pre-loaded models)
python netbox/manage.py nbshell

# Run RQ worker for background jobs
python netbox/manage.py rqworker

# Run a custom script
python netbox/manage.py runscript <script_name>

# Sync data from a DataSource
python netbox/manage.py syncdatasource <datasource_name>

# Perform housekeeping tasks (cleanup old records)
python netbox/manage.py housekeeping

# Reindex search database
python netbox/manage.py reindex

# Rebuild IP prefix hierarchy
python netbox/manage.py rebuild_prefixes

# Calculate cached counter values
python netbox/manage.py calculate_cached_counts

# Trace cable paths
python netbox/manage.py trace_paths
```

### Documentation
```bash
# Build documentation (MkDocs)
mkdocs build

# Serve documentation locally
mkdocs serve
```

---

## High-Level Architecture

### Core Django Apps

NetBox is organized into 11 core Django apps under `netbox/`:

| App | Description |
|-----|-------------|
| account | Authentication, login/logout, OAuth integration |
| circuits | Provider circuits and circuit terminations |
| core | Central infrastructure (ObjectType, ObjectChange, DataFile, Jobs) |
| dcim | Data Center Infrastructure (Sites, Racks, Devices, Cables, Power, Modules) |
| extras | Extensibility (CustomFields, Tags, Scripts, EventRules, Webhooks) |
| ipam | IP Address Management (Prefixes, IPs, VRFs, VLANs, ASNs) |
| tenancy | Multi-tenancy (Tenants, Tenant Groups, Contacts) |
| users | User management and permissions (User, Group, Token) |
| utilities | Shared utilities (Forms, Views, Tables, Filters, API helpers) |
| virtualization | Virtual machines (VMs, Clusters, VM Interfaces) |
| vpn | VPN configuration (Tunnels, IKE/IPSec) |
| wireless | Wireless networks (WLANs, Wireless Links) |

### Standard App Structure

```
app/
├── models/              # Data models
├── forms/               # Django forms (model_forms, bulk_edit, bulk_import)
├── tables/              # django-tables2 definitions
├── filtersets.py        # django-filter FilterSet classes
├── views.py             # Web UI views
├── urls.py              # Web URL routing
├── api/                 # REST API (serializers, views, urls)
├── graphql/             # GraphQL schema (types, filters)
├── search.py            # Search index definitions
├── tests/               # Test suite
└── migrations/          # Database migrations
```

---

## Quick Reference

### Model Inheritance Hierarchy

```
models.Model (Django)
└─ NetBoxModel
   ├─ PrimaryModel         # Full feature set (Device, Site, IPAddress, etc.)
   ├─ OrganizationalModel  # Container objects (Region, Manufacturer, etc.)
   ├─ ChangeLoggedModel    # Minimal tracking (Tag, CustomField, etc.)
   └─ NestedGroupModel     # Hierarchical (Region, Location, TenantGroup)
```

### Key Model Mixins (netbox/netbox/models/features.py)

- `ChangeLoggingMixin`: created, last_updated, snapshot()
- `CloningMixin`: clone() support
- `CustomFieldsMixin`: custom_field_data JSONField
- `TagsMixin`: tags via django-taggit
- `ExportTemplatesMixin`: Jinja2 export
- `ImageAttachmentsMixin`: image uploads
- `BookmarksMixin`: user favorites
- `JournalingMixin`: journal entries
- `ContactsMixin`: contact assignments
- `EventRulesMixin`: webhook/script triggers

### Generic Views (netbox/utilities/views.py)

| View | Purpose |
|------|---------|
| ObjectView | Single object display |
| ObjectListView | List with filtering |
| ObjectEditView | Create/edit form |
| ObjectDeleteView | Delete confirmation |
| BulkImportView | CSV import |
| BulkEditView | Multi-object edit |
| BulkDeleteView | Multi-object delete |

### View Mixins

- `ObjectPermissionRequiredMixin`: Permission checking with RestrictedQuerySet
- `GetReturnURLMixin`: Redirect URL resolution
- `GetRelatedModelsMixin`: Related object discovery

### Base Form Classes (netbox/utilities/forms/)

- `NetBoxModelForm`: Standard model form with custom fields, tags
- `NetBoxModelImportForm`: CSV bulk import
- `NetBoxModelBulkEditForm`: Bulk modification
- `NetBoxModelFilterSetForm`: Filter form

### API Classes (netbox/netbox/api/)

**ViewSets** (viewsets/):
- `BaseViewSet`: Permission-based queryset restriction
- `NetBoxReadOnlyModelViewSet`: GET only
- `NetBoxModelViewSet`: Full CRUD + bulk operations

**Serializers** (serializers/):
- `BaseModelSerializer`: url, display_url, display fields
- `ValidatedModelSerializer`: Enforces full_clean()
- `NetBoxModelSerializer`: Full feature serializer

### FilterSet Base (netbox/utilities/filtersets.py)

- `BaseFilterSet`: MultiValue filters, SavedFilter support
- `NetBoxModelFilterSet`: Adds q (search), tag, tag_id filters

### Permission System

`RestrictedQuerySet.restrict(user, action)` filters objects by user permissions:
```python
sites = Site.objects.restrict(request.user, 'view')
devices = Device.objects.restrict(request.user, 'change')
```

---

## Important File Paths

### Core Framework
- `netbox/netbox/settings.py` - Django settings
- `netbox/netbox/urls.py` - Root URL configuration
- `netbox/netbox/registry.py` - Central registry
- `netbox/netbox/models/` - Base model classes
- `netbox/netbox/models/features.py` - Model mixins

### Utilities
- `netbox/utilities/views.py` - View mixins and helpers
- `netbox/utilities/forms/` - Form classes and mixins
- `netbox/utilities/tables/` - Table classes
- `netbox/utilities/filtersets.py` - FilterSet base classes
- `netbox/utilities/permissions.py` - Permission helpers
- `netbox/utilities/querysets.py` - RestrictedQuerySet
- `netbox/utilities/testing/` - Test base classes

### API
- `netbox/netbox/api/viewsets/` - ViewSet base classes
- `netbox/netbox/api/serializers/` - Serializer base classes
- `netbox/netbox/graphql/schema.py` - GraphQL schema

### Plugin System
- `netbox/netbox/plugins/__init__.py` - PluginConfig
- `netbox/netbox/plugins/registration.py` - Plugin registration

### Core Apps Pattern
For each app (`dcim`, `ipam`, `extras`, etc.):
- `netbox/<app>/models/` - Data models
- `netbox/<app>/forms/` - Forms
- `netbox/<app>/tables/` - Tables
- `netbox/<app>/filtersets.py` - FilterSets
- `netbox/<app>/views.py` - Views
- `netbox/<app>/api/` - API implementation
- `netbox/<app>/tests/` - Tests

### Extras
- `netbox/extras/scripts.py` - Script base classes
- `netbox/extras/webhooks.py` - Webhook delivery
- `netbox/extras/events.py` - Event processing

---

## Contributing Guidelines

- **No AI-generated code**: All contributions must be entirely original work
- **Branch**: Base new PRs off `main` branch (trunk-based development)
- **Issue First**: Open and get assigned an issue before submitting a PR
- **Tests Required**: All new functionality must include relevant tests
- **Code Quality**:
  - Python syntax must be valid
  - All tests must pass: `./manage.py test`
  - PEP 8 compliance (line length 120 chars)
  - Ruff linting must pass
  - Frontend: ESLint, TypeScript, Prettier compliance
- **Changelog**: Maintainers handle changelog entries
- **Documentation**: Update docs for new features

---

## Additional Resources

- **Official Documentation**: https://docs.netbox.dev/
- **API Documentation**: `/api/schema/swagger-ui/` and `/api/schema/redoc/`
- **Plugin Tutorial**: https://github.com/netbox-community/netbox-plugin-tutorial
- **Community**: GitHub Discussions and NetDev Slack (#netbox channel)
- **Demo Instance**: https://demo.netbox.dev/
