import os
import subprocess

import streamlit as st


def delete_html_files():
    folder_path = os.getcwd()  # Get the current working directory
    html_files = [file for file in os.listdir(folder_path) if file.endswith(".html")]

    for file in html_files:
        file_path = os.path.join(folder_path, file)
        os.remove(file_path)

    st.success("HTML files deleted successfully!")


def download_html_files():
    folder_path = os.getcwd()  # Get the current working directory
    sh_file_path = os.path.join(
        folder_path, "data/get_pages.sh"
    ) 

    if os.path.exists(sh_file_path):
        subprocess.run(["/bin/bash", sh_file_path])
        st.success("Download pages script executed successfully!")
    else:
        st.error("Shell script not found in the current directory.")


# Button to call the specific shell script
if st.button("Call Shell Script"):
    download_html_files()

# Button to delete HTML files
if st.button("Delete HTML Files"):
    delete_html_files()
