-- Execute no SQL Editor do Supabase.
create extension if not exists pgcrypto;
create table if not exists public.devices (
 id text primary key, name text not null, icon text default '▣',
 description text default '', created_at timestamptz default now()
);
create table if not exists public.apps (
 id uuid primary key default gen_random_uuid(), name text not null,
 description text default '', download_url text default '', badge text default '',
 device_ids text[] default '{}', created_at timestamptz default now()
);
create table if not exists public.tutorials (
 id uuid primary key default gen_random_uuid(), title text not null,
 body text not null default '', created_at timestamptz default now()
);
create table if not exists public.faqs (
 id uuid primary key default gen_random_uuid(), question text not null,
 answer text not null default '', created_at timestamptz default now()
);
create table if not exists public.site_settings (
 id uuid primary key default gen_random_uuid(), key text unique not null,
 value text default '', created_at timestamptz default now()
);
alter table public.devices enable row level security;
alter table public.apps enable row level security;
alter table public.tutorials enable row level security;
alter table public.faqs enable row level security;
alter table public.site_settings enable row level security;
-- Leitura pública para conteúdo do site.
create policy "public read devices" on public.devices for select using (true);
create policy "public read apps" on public.apps for select using (true);
create policy "public read tutorials" on public.tutorials for select using (true);
create policy "public read faqs" on public.faqs for select using (true);
create policy "public read settings" on public.site_settings for select using (true);
-- Escrita somente por usuários autenticados. Restrinja a criação de usuários
-- no painel Supabase e habilite MFA para a conta administradora.
create policy "authenticated manage devices" on public.devices for all to authenticated using (true) with check (true);
create policy "authenticated manage apps" on public.apps for all to authenticated using (true) with check (true);
create policy "authenticated manage tutorials" on public.tutorials for all to authenticated using (true) with check (true);
create policy "authenticated manage faqs" on public.faqs for all to authenticated using (true) with check (true);
create policy "authenticated manage settings" on public.site_settings for all to authenticated using (true) with check (true);
insert into public.devices(id,name,icon,description) values
('samsung','Samsung Smart TV','▣','Instalação em televisores Samsung'),
('lg','LG Smart TV','▣','Instalação em televisores LG'),
('android','Android TV / Google TV','◫','TVs e aparelhos Android'),
('tvbox','TV Box','▰','Dispositivos TV Box'),
('fire','Fire TV Stick','⌁','Amazon Fire TV'),
('mobile','Celular e Tablet','▯','Android e iOS'),
('computer','Computador','▱','Acesso pelo navegador'),
('projector','Projetor Android','◉','Projetores com Android')
on conflict(id) do nothing;
insert into public.apps(name,description,badge,device_ids) values
('ZUXO Player','Aplicativo para dispositivos compatíveis.','Recomendado',array['samsung','lg','android']),
('Easy Player','Uma opção prática para dispositivos Android.','Android',array['android','tvbox','mobile']),
('Slim Smart','Alternativa para aparelhos compatíveis.','Compatível',array['samsung','lg','android','tvbox']),
('Pulse Player','Interface leve e moderna.','Novidade',array['android','tvbox','fire','mobile']);
insert into public.tutorials(title,body) values
('Como instalar na Samsung Smart TV','Abra a loja de aplicativos da TV, pesquise o aplicativo indicado e instale. Depois, abra o app e siga os dados de configuração fornecidos pelo suporte.'),
('Como instalar na LG Smart TV','Acesse a LG Content Store, procure o aplicativo indicado e instale. Abra o aplicativo e configure com os dados recebidos.'),
('Como instalar no Android TV ou TV Box','Abra a Play Store ou siga o método de instalação informado pelo suporte. Instale o aplicativo compatível e insira seus dados de acesso.');
insert into public.faqs(question,answer) values
('Onde encontro o aplicativo correto?','Selecione seu dispositivo na seção de compatibilidade para ver as opções cadastradas.'),
('Como faço a instalação?','Acesse a área de tutoriais e escolha o passo a passo do seu dispositivo.'),
('Não consegui configurar. O que faço?','Entre em contato com o suporte ZapPlay para receber orientação.');
