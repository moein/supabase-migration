CREATE FUNCTION public.check_no_task_in_progress() RETURNS trigger
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF (SELECT count(*) FROM tasks s WHERE s.user_id = NEW.user_id AND status = 1) > 0
    THEN
        RAISE EXCEPTION 'task_in_progress';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TABLE public.tasks
(
    id         character varying NOT NULL,
    user_id    uuid              NOT NULL,
    name       character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
);

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);

CREATE TRIGGER tasks_insert
    AFTER INSERT
    ON public.tasks
    FOR EACH ROW
EXECUTE FUNCTION supabase_functions.http_request(
        'WEBHOOK_URL', 'POST',
        '{"Content-type":"application/json","Authorization":"WEBHOOK_SECRET","Event":"tasks.insert"}', '{}', '1000');

CREATE TRIGGER check_no_task_in_progress_trigger
    BEFORE INSERT
    ON public.tasks
    FOR EACH ROW
EXECUTE FUNCTION public.check_no_task_in_progress();

-- Constraint
ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id);

-- Policies
CREATE POLICY "Allow owners" ON public.tasks USING ((auth.uid() = user_id));

-- Enabling RLS
ALTER TABLE public.users
    ENABLE ROW LEVEL SECURITY;