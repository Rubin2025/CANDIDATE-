NO-CODE VERCEL ELECTION VERSION

Commit these files to the GitHub repo.

Vercel Production environment variables:
SUPABASE_URL
SUPABASE_SERVICE_ROLE_KEY
ADMIN_PASSWORD

The voter page asks only for a name and candidate. The name is NOT sent to the ballot database. The ballot is aggregate-only.

IMPORTANT: With no code/login/verification, the system cannot technically guarantee that one physical person votes only once. It does guarantee a 30-vote maximum and prevents the same submission from being stored twice by the same server request, but a person can submit again from another browser/device.
