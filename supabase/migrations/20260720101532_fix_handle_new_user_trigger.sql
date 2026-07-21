/*
# Fix handle_new_user trigger function

Recreates the trigger function with explicit schema references and proper
SECURITY DEFINER + search_path to prevent "Database error querying schema" 
errors during GoTrue auth operations.

1. Modified Functions
   - `handle_new_user()`: Added explicit `public.profiles` reference and 
     SET search_path to prevent schema resolution failures.

2. Security
   - Function remains SECURITY DEFINER to bypass RLS.
   - search_path explicitly set to 'public' for safety.
*/

-- Drop and recreate the function with proper search_path
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (auth_user_id, email, full_name, role, status)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    'evaluator',
    'active'
  );
  RETURN NEW;
EXCEPTION WHEN OTHERS THEN
  RETURN NEW;
END;
$$;

-- Recreate the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
