# CranberrieStudios Infrastructure Agent

## Overview
This agent manages CranberrieStudios' Microsoft 365, Azure, SharePoint, and Cloudflare infrastructure.

## Credentials & Access

### Microsoft 365 / Azure
- **Admin Email**: joseph@cranberriestudios.com
- **Tenant ID**: 60ad61b7-4d95-4775-8a0a-0f211b601c5c
- **Tenant Domain**: cranberriestudios.com
- **Default Domain**: CranberrieStudios.onmicrosoft.com

### SharePoint Sites
1. **Main Company Portal**
   - URL: https://cranberriestudios.sharepoint.com/
   - Type: Communication Site (Root)
   - Purpose: Company-wide information and announcements

2. **DiceMatrix (Personal Storage)**
   - URL: https://cranberriestudios.sharepoint.com/sites/dicematrix
   - Email: admin@dicematrix.cloud
   - Custom Domain: dicematrix.cloud (redirects via Cloudflare)
   - Group ID: b0334a21-1c66-418a-87b3-64bce0c3ae0e

### Cloudflare Configuration
- **Account**: Admin@cranberriestudios.com's Account
- **Account ID**: 62a2be2d56aa68947e99ce87679a9001
- **Domains Managed**:
  - cranberriestudios.com
  - dicematrix.cloud
  - donniedice.com

#### DiceMatrix.cloud Zone
- **Zone ID**: 0a689272ec463ca9d0d6f0b4e8001d30
- **DNS Configuration**:
  - A Record: @ → 192.0.2.1 (Proxied)
  - A Record: www → 192.0.2.1 (Proxied)
  - Page Rule: *dicematrix.cloud/* → https://cranberriestudios.sharepoint.com/sites/dicematrix

### API Tokens
- **Cloudflare Full Access Token**: gqhjRpRJgbyuKBHD5pKqt4T-p0NfB_HBBPba6oMr
- **Token Creator**: O2tEdLdfyqVIl_vfY8bp-pCGxTm_yYwp2eZToUaJ

## Common Tasks

### 1. SharePoint Management

#### List all SharePoint sites:
```bash
az rest --method GET --uri "https://graph.microsoft.com/v1.0/sites?search=*" --query "value[].{name:displayName, url:webUrl}"
```

#### Manage Microsoft 365 Groups:
```bash
# List groups
az rest --method GET --uri "https://graph.microsoft.com/v1.0/groups" --query "value[?contains(mail, 'cranberriestudios.com')].{name:displayName, id:id, mail:mail}"

# Delete a group
az rest --method DELETE --uri "https://graph.microsoft.com/v1.0/groups/{group-id}"

# Restore deleted group
az rest --method POST --uri "https://graph.microsoft.com/v1.0/directory/deletedItems/{id}/restore"
```

### 2. Cloudflare DNS Management

#### List DNS Records:
```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones/0a689272ec463ca9d0d6f0b4e8001d30/dns_records" \
  -H "Authorization: Bearer gqhjRpRJgbyuKBHD5pKqt4T-p0NfB_HBBPba6oMr"
```

#### Create DNS Record:
```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/0a689272ec463ca9d0d6f0b4e8001d30/dns_records" \
  -H "Authorization: Bearer gqhjRpRJgbyuKBHD5pKqt4T-p0NfB_HBBPba6oMr" \
  -H "Content-Type: application/json" \
  --data '{"type":"A","name":"subdomain","content":"IP_ADDRESS","ttl":1,"proxied":true}'
```

#### Manage Page Rules:
```bash
# List Page Rules
curl -X GET "https://api.cloudflare.com/client/v4/zones/0a689272ec463ca9d0d6f0b4e8001d30/pagerules" \
  -H "Authorization: Bearer gqhjRpRJgbyuKBHD5pKqt4T-p0NfB_HBBPba6oMr"

# Create Page Rule for redirect
curl -X POST "https://api.cloudflare.com/client/v4/zones/0a689272ec463ca9d0d6f0b4e8001d30/pagerules" \
  -H "Authorization: Bearer gqhjRpRJgbyuKBHD5pKqt4T-p0NfB_HBBPba6oMr" \
  -H "Content-Type: application/json" \
  --data '{"targets":[{"target":"url","constraint":{"operator":"matches","value":"URL_PATTERN"}}],"actions":[{"id":"forwarding_url","value":{"url":"DESTINATION_URL","status_code":301}}],"priority":1,"status":"active"}'
```

### 3. Azure CLI Commands

#### Login:
```bash
az login --tenant cranberriestudios.com
```

#### Account Management:
```bash
# Show current account
az account show

# List all accessible subscriptions
az account list --output table
```

### 4. User Management

#### Add user to SharePoint/Group:
```bash
# Get user ID
az rest --method GET --uri "https://graph.microsoft.com/v1.0/users/joseph@cranberriestudios.com" --query "id"

# Add to group as owner
az ad group owner add --group {group-id} --owner-object-id {user-id}

# Add to group as member
az ad group member add --group {group-id} --member-id {user-id}
```

## Troubleshooting

### Common Issues:

1. **Cloudflare Redirect Issues**
   - Clear Cloudflare cache
   - Check Page Rules order (priority matters)
   - Verify DNS records are proxied (orange cloud)

2. **SharePoint Access Issues**
   - Verify group membership
   - Check site permissions in SharePoint Admin Center
   - Ensure licenses are assigned in Microsoft 365 Admin

3. **API Token Issues**
   - Tokens may expire - regenerate using token creator
   - Verify token permissions match required operations
   - Check zone/account IDs are correct

## Infrastructure Map

```
CranberrieStudios Infrastructure
├── Microsoft 365 (cranberriestudios.com)
│   ├── SharePoint Online
│   │   ├── Root Site (https://cranberriestudios.sharepoint.com)
│   │   └── DiceMatrix Site (/sites/dicematrix)
│   ├── Exchange Online (Email)
│   └── Azure AD (User Management)
├── Cloudflare
│   ├── cranberriestudios.com (DNS)
│   ├── dicematrix.cloud (DNS + Redirects)
│   └── donniedice.com (DNS)
└── Azure Subscription
    └── Azure subscription 1 (ed6db5bb-adda-4561-8c17-03eeef01ac35)
```

## Quick Actions

### Reset DiceMatrix Redirect:
```bash
# 1. Delete existing Page Rule
curl -X GET "https://api.cloudflare.com/client/v4/zones/0a689272ec463ca9d0d6f0b4e8001d30/pagerules" \
  -H "Authorization: Bearer gqhjRpRJgbyuKBHD5pKqt4T-p0NfB_HBBPba6oMr"
# Note the ID, then delete it

# 2. Create new redirect
curl -X POST "https://api.cloudflare.com/client/v4/zones/0a689272ec463ca9d0d6f0b4e8001d30/pagerules" \
  -H "Authorization: Bearer gqhjRpRJgbyuKBHD5pKqt4T-p0NfB_HBBPba6oMr" \
  -H "Content-Type: application/json" \
  --data '{"targets":[{"target":"url","constraint":{"operator":"matches","value":"*dicematrix.cloud*"}}],"actions":[{"id":"forwarding_url","value":{"url":"https://cranberriestudios.sharepoint.com/sites/dicematrix","status_code":301}}],"priority":1,"status":"active"}'
```

### Create New SharePoint Site:
```bash
az rest --method POST --uri "https://graph.microsoft.com/v1.0/groups" \
  --headers "Content-Type=application/json" \
  --body '{"displayName":"SITE_NAME","mailNickname":"SITE_NICKNAME","description":"DESCRIPTION","mailEnabled":true,"securityEnabled":false,"groupTypes":["Unified"],"visibility":"Private"}'
```

## Notes
- Always backup before making major changes
- Test DNS changes in staging first if possible
- SharePoint changes may take 15-30 minutes to propagate
- Cloudflare changes are usually instant but may be cached

## Support Contacts
- Microsoft 365 Support: Via Admin Center
- Cloudflare Support: Via Dashboard
- Azure Support: Via Azure Portal

Last Updated: 2025-08-11