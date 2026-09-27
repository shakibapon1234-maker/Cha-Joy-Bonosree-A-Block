-- Run this migration once in Supabase SQL Editor for an existing ledger.

alter table public.ledger_entries
    add column if not exists transfer_account text;

alter table public.ledger_entries
    drop constraint if exists ledger_entries_type_check;

alter table public.ledger_entries
    add constraint ledger_entries_type_check
    check (type in ('income', 'expense', 'transfer'));
