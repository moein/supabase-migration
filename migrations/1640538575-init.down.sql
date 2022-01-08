DROP POLICY "Allow owners" ON public.data_blocks;
ALTER TABLE ONLY public.admins DROP CONSTRAINT tasks_user_id_fkey;
DROP TRIGGER check_no_task_in_progress_trigger ON public.tasks;
ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkey;
DROP TABLE public.tasks;
DROP FUNCTION public.check_no_task_in_progress();
