-- Run this migration once in Supabase SQL Editor for an existing ledger.

alter table public.ledger_entries
    add column if not exists transfer_account text;

alter table public.ledger_entries
    drop constraint if exists ledger_entries_type_check;

alter table public.ledger_entries
    add constraint ledger_entries_type_check
    check (type in ('income', 'expense', 'transfer'));

-- Normalize all known spelling variants of Ismail's shareholder name.
update public.ledger_entries
set category = 'Ismail Hossain'
where type = 'income'
  and lower(trim(regexp_replace(category, '\s+', ' ', 'g')))
      in ('ismail hossein', 'ismail hossain', 'ismail hussain', 'ismail husain', 'ismail hosain');

delete from public.ledger_sources
where lower(trim(regexp_replace(name, '\s+', ' ', 'g')))
      in ('ismail hossein', 'ismail hossain', 'ismail hussain', 'ismail husain', 'ismail hosain')
  and name <> 'Ismail Hossain';

insert into public.ledger_sources (name)
select 'Ismail Hossain'
where not exists (
    select 1 from public.ledger_sources where name = 'Ismail Hossain'
);
