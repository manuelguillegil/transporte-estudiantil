-- Column: public.estudiantes.carnet

-- ALTER TABLE public.estudiantes DROP COLUMN carnet;

ALTER TABLE public.estudiantes
    ADD COLUMN carnet integer NOT NULL;
alter table public.estudiantes
	add primary key (carnet);