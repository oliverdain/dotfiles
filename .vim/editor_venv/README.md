We need various Python things installed to make Python editing work (e.g. `pyls`, `flake8`, etc.). But we often are
working in a virtual environment or for whatever reason don't want to install our own stuff in the current Python
environment. Instead we install all the stuff we need here and then patch this `venv/lib/.../site-packages` into the
`$PYTHONPATH` so it can be used in any venv.
