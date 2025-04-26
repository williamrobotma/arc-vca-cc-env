#!/usr/bin/env bash

install_dir="${1:-$HOME}"

module load StdEnv/2023

module_load_line="module load gcc arrow/19.0.1 python/3.13 ipykernel/2025a python-build-bundle/2025a"
eval "$module_load_line"



if [ -d "$install_dir/.venv-tahoe" ]; then
    rm -r "$install_dir/.venv-tahoe"
fi

virtualenv --no-download "$install_dir/.venv-tahoe"
source "$install_dir/.venv-tahoe/bin/activate"
pip install --no-index --upgrade pip



mkdir -p "./wheels"
if ! [ -f "./wheels/google_cloud_storage-3.0.0-py2.py3-none-any.whl" ]; then
    pip download --no-deps "google-cloud-storage==3.0.0" -d ./wheels
fi
if ! [ -f "./wheels/jupyter-1.1.1-py2.py3-none-any.whl" ]; then
    pip download --no-deps "jupyter==1.1.1" -d ./wheels
fi
if ! [ -f "./wheels/installer-0.7.0-py3-none-any.whl" ]; then
    pip download --no-deps "installer==0.7.0" -d ./wheels
fi
if ! [ -f "./wheels/dulwich-0.22.8-py3-none-any.whl" ]; then
    pip download --no-deps "dulwich==0.22.8" -d ./wheels
fi
if ! [ -f "./wheels/trove_classifiers-2025.4.11.15-py3-none-any.whl" ]; then
    pip download --no-deps "trove-classifiers==2025.4.11.15" -d ./wheels
fi


pip install --no-index -r requirements.txt

# add the module load lines to the activate script
awk -v line="$module_load_line" '
/^fi/ && !found {
    print $0;
    print "";
    print line;
    found=1;
    next;
}
{print}' "$install_dir/.venv-tahoe/bin/activate" > "$install_dir/.venv-tahoe/bin/activate.tmp"
mv "$install_dir/.venv-tahoe/bin/activate.tmp" "$install_dir/.venv-tahoe/bin/activate"



