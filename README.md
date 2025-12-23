# Home

A Phoenix application with authentication support including email/password and social login via GitHub and Google.

## Requirements

- Elixir 1.14+
- PostgreSQL
- Node.js (for assets)

## Setup

1. Install dependencies:

```bash
mix deps.get
```

2. Create and migrate database:

```bash
mix ecto.setup
```

3. Start Phoenix server:

```bash
mix phx.server
```

Visit [`localhost:4000`](http://localhost:4000) from your browser.

---

## OAuth Configuration

This app supports social authentication with **GitHub** and **Google**. To enable these providers, you'll need to create OAuth applications and configure the credentials.

### Environment Variables

Set these environment variables before starting your application:

```bash
export GITHUB_CLIENT_ID="your_github_client_id"
export GITHUB_CLIENT_SECRET="your_github_client_secret"
export GOOGLE_CLIENT_ID="your_google_client_id"
export GOOGLE_CLIENT_SECRET="your_google_client_secret"
```

Or create a `.env` file in the project root (don't commit this file!):

```bash
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
```

Then source it: `source .env`

---

## GitHub OAuth Setup

### 1. Create a GitHub OAuth Application

1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Click **"OAuth Apps"** in the left sidebar
3. Click **"New OAuth App"**
4. Fill in the application details:

   | Field | Development Value | Production Value |
   |-------|-------------------|------------------|
   | **Application name** | `Home Dev` | `Home` |
   | **Homepage URL** | `http://localhost:4000` | `https://yourdomain.com` |
   | **Authorization callback URL** | `http://localhost:4000/auth/github/callback` | `https://yourdomain.com/auth/github/callback` |

5. Click **"Register application"**

### 2. Get Your Credentials

After creating the app:

1. Copy the **Client ID** displayed on the app page
2. Click **"Generate a new client secret"**
3. Copy the **Client Secret** immediately (it won't be shown again!)

### 3. Configure Environment

```bash
export GITHUB_CLIENT_ID="Iv1.xxxxxxxxxx"
export GITHUB_CLIENT_SECRET="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

---

## Google OAuth Setup

### 1. Create a Google Cloud Project

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Click the project dropdown at the top and select **"New Project"**
3. Enter a project name (e.g., "Home App") and click **"Create"**
4. Wait for the project to be created and select it

### 2. Enable the Google+ API (or People API)

1. Go to **"APIs & Services"** → **"Library"**
2. Search for **"Google+ API"** or **"People API"**
3. Click on it and press **"Enable"**

### 3. Configure OAuth Consent Screen

1. Go to **"APIs & Services"** → **"OAuth consent screen"**
2. Choose **"External"** user type (unless you have a Google Workspace)
3. Click **"Create"**
4. Fill in the required fields:
   - **App name**: `Home`
   - **User support email**: Your email
   - **Developer contact email**: Your email
5. Click **"Save and Continue"**
6. On the **Scopes** page:
   - Click **"Add or Remove Scopes"**
   - Select `email` and `profile` scopes
   - Click **"Update"** then **"Save and Continue"**
7. On the **Test users** page (for development):
   - Add your email as a test user
   - Click **"Save and Continue"**
8. Review and click **"Back to Dashboard"**

### 4. Create OAuth Credentials

1. Go to **"APIs & Services"** → **"Credentials"**
2. Click **"+ Create Credentials"** → **"OAuth client ID"**
3. Select **"Web application"** as the application type
4. Enter a name (e.g., "Home Web Client")
5. Add **Authorized JavaScript origins**:

   | Environment | URI |
   |-------------|-----|
   | Development | `http://localhost:4000` |
   | Production | `https://yourdomain.com` |

6. Add **Authorized redirect URIs**:

   | Environment | URI |
   |-------------|-----|
   | Development | `http://localhost:4000/auth/google/callback` |
   | Production | `https://yourdomain.com/auth/google/callback` |

7. Click **"Create"**

### 5. Get Your Credentials

A dialog will appear with your credentials:

1. Copy the **Client ID** 
2. Copy the **Client Secret**

### 6. Configure Environment

```bash
export GOOGLE_CLIENT_ID="xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com"
export GOOGLE_CLIENT_SECRET="GOCSPX-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

---

## Production Deployment

For production, ensure you:

1. **Update OAuth callback URLs** in both GitHub and Google to use your production domain
2. **Set environment variables** on your hosting platform:
   ```bash
   GITHUB_CLIENT_ID=xxx
   GITHUB_CLIENT_SECRET=xxx
   GOOGLE_CLIENT_ID=xxx
   GOOGLE_CLIENT_SECRET=xxx
   DATABASE_URL=ecto://user:pass@host/database
   SECRET_KEY_BASE=xxx  # Generate with: mix phx.gen.secret
   PHX_HOST=yourdomain.com
   ```

3. **For Google**: Move your OAuth app from "Testing" to "Production":
   - Go to OAuth consent screen
   - Click **"Publish App"**
   - Complete the verification process if required

---

## Authentication Routes

| Route | Description |
|-------|-------------|
| `/users/register` | Email registration |
| `/users/log_in` | Email login |
| `/users/log_out` | Logout |
| `/users/settings` | Account settings |
| `/users/reset_password` | Password reset |
| `/auth/github` | GitHub OAuth login |
| `/auth/google` | Google OAuth login |

---

## Troubleshooting

### "redirect_uri_mismatch" error
- Ensure the callback URL in your OAuth app settings **exactly** matches:
  - GitHub: `http://localhost:4000/auth/github/callback`
  - Google: `http://localhost:4000/auth/google/callback`

### "access_denied" error (Google)
- Make sure your email is added as a test user in the OAuth consent screen
- Or publish your app to production mode

### No email returned from GitHub
- Ensure your GitHub profile has a **public email** set, OR
- The app requests `user:email` scope (already configured)

### OAuth buttons not working
- Check that environment variables are set: `echo $GITHUB_CLIENT_ID`
- Restart the Phoenix server after setting environment variables

---

## Learn More

- [Phoenix Framework](https://www.phoenixframework.org/)
- [Ueberauth](https://github.com/ueberauth/ueberauth)
- [GitHub OAuth Docs](https://docs.github.com/en/developers/apps/building-oauth-apps)
- [Google OAuth Docs](https://developers.google.com/identity/protocols/oauth2)
