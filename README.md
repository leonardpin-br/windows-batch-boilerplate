# Batch (Windows) starter project to create applications.
This starter kit is preconfigured to facilitate fast development.



## Inspirations and reference
This kit is heavily influenced by the courses
[Batch Script Programming Crash Course (CMD)](https://www.udemy.com/course/batch-script-programming/),
taught by Narendra Dwivedi, and
[Batch Tutorials](https://www.youtube.com/playlist?list=PL69BE3BF7D0BB69C4),
taught by John Hammond.



## Why is it better than a script in a single file?
This starter kit allows the development of a more powerfull tool. Instead of
creating a single script, the user of this kit will be able to create a small
application.



## It includes
    1. The code is heavly commented.
    2. The app is split in files for easy organization and reading.
    3. Imports are preconfigured and the files have examples.



## Folder structure
```
<project_root>
|- resources                    (good to have and needed files)
    |- img                      (images containing useful information)
|- src                          (the example app)

```



## Which file will be executed?
Using this starter kit, the Main.bat (``<project_root>\src\Main.bat``) will be
the file being executed.

### From where you run it makes a big difference.

If you want to run it from the **<project_root>**, type ``src\Main.bat``. The code
inside the main script was written to be run from the root.

If you change the directory to the ``src`` folder (``cd src``), you will have to
change the code inside ``src\Main.bat``, because the "import" of the global
variables and the functions have the ``src`` as a prefix
(``CALL src\Functions.bat :clear_screen``).
