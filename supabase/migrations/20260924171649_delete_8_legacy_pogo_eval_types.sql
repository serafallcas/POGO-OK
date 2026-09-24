/*
# Delete 8 legacy POGO evaluation_types (orphaned after merge)

## Summary
Physically removes the 8 deactivated evaluation_types (pogo_1, pogo_2_a through pogo_2_f)
that were replaced by the unified 'pogo' type in the previous migration. All dependent rows
(assessments, domains, processes, questionnaires, questions) were already re-pointed to the
new 'pogo' type -- verified at 0 references before deletion.

## Changes
- DELETE: 8 rows from evaluation_types where code IN (pogo_1, pogo_2_a..pogo_2_f).

## Security
- No RLS or policy changes.

## Important Notes
1. Pre-deletion verification confirmed 0 foreign key references across all 5 dependent tables.
2. The unified 'pogo' type (is_active=true) remains untouched.
*/

DELETE FROM evaluation_types
WHERE code IN ('pogo_1','pogo_2_a','pogo_2_b','pogo_2_c','pogo_2_d_a','pogo_2_d_b','pogo_2_e','pogo_2_f');