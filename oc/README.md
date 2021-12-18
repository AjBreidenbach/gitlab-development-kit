Run the **build.sh** script to build the development image.

Run the **run.sh** script to create a container and start the gdk install process.
The gdk process runs in the background and a bash shell is started.

Pass the gitlab-oc project directory as the first argument to **run.sh**.  Additional arguments are passed to `docker run` (such as -p to expose ports).  The first time the container runs it will run `gdk install` for you.  Afterwards, starting the container will run `gdk start`.

If you are not sure gitlab install completed successfully, you can cd into `gitlab-development-kit/` and `gdk install` again.  It will not rebuild any artifacts.

Inside the project directory, your gitlab-oc project will be mounted at `gitlab-development-kit/gitlab`
You may need to start `rails s`, but webpack should be started automatically.

**Note:** your gitlab-oc project should be on the same disk as your docker images, because gdk creates hardlinks.
