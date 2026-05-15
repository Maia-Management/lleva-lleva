-- Replace old public WhatsApp number in seeded listing/profile data.
-- Public Maia ecosystem CTAs should route to the bot number: +1 903 459 8763.

UPDATE public.listings
SET description = replace(description, '+573174370575', '+19034598763')
WHERE description LIKE '%+573174370575%';

UPDATE public.profiles
SET whatsapp_number = '+19034598763'
WHERE whatsapp_number = '+573174370575';
