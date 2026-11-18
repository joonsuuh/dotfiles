"""IPython settings: vi keys in the terminal shell."""

c = get_config()  # noqa: F821  # IPython defines get_config.

c.TerminalInteractiveShell.editing_mode = "vi"
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
