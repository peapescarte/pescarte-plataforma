CREATE OR REPLACE FUNCTION create_user(
    email text,
    password text,
    user_id uuid
) RETURNS uuid AS $$
  declare
  encrypted_pw text;
BEGIN
  encrypted_pw := crypt(password, gen_salt('bf'));
  
  INSERT INTO auth.users
    (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, recovery_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token)
  VALUES
    ('00000000-0000-0000-0000-000000000000', user_id, 'authenticated', 'admin', email, encrypted_pw, now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
  
  INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
  VALUES
    (gen_random_uuid(), user_id, format('{"sub":"%s","email":"%s"}', user_id::text, email)::jsonb, 'email', user_id, now(), now(), now());

  RETURN(SELECT id FROM auth.users where id = user_id);
END;
$$ LANGUAGE plpgsql;

do $$
begin
  perform create_user('dev.admin@pescarte.org.br', 'Senha!123', 'ed31ec14-b4bc-4e24-a877-91fb8d0d2de4');
  perform create_user('dev.user@pescarte.org.br', 'Senha!123', '8ecdf5e3-eba3-4dc8-a974-0427ebd10e59');
  perform create_user('dev.user1@pescarte.org.br', 'Senha!123', '89451354-c041-4bea-ab74-bd6fa9b2407b');
  perform create_user('dev.user2@pescarte.org.br', 'Senha!123', 'cb4397a6-4206-4b36-af05-1518a22cea33');
  perform create_user('dev.user3@pescarte.org.br', 'Senha!123', '006019fe-10a2-4aa9-8c25-0407d09fbe43');
end$$;
