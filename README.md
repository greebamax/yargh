# Yet another Git hooks collection
Contains:
 - [Git commit message checker](https://github.com/greebamax/yaghc#git-commit-message-checker)
 - [Pre-commit linter](https://github.com/greebamax/yaghc#pre-commit-linter)

##### Git commit message checker
The hook script validates commit messages on each commit.
Allowed format:
> JRA-1234 Commit message preceded by a single space

Otherwise you can use one of allowed words at the start of commit message to determine commit kind.
##### Pre-commit linter
Run ESlint only on changed and added to commit **.js** files

#### Installation
Copy hook file to **.git/hooks/** directory, remove **.sh** and make it executable
```sh
$ cp commit-msg.sh .git/hooks/commit-msg
$ chmod +x .git/hooks/commit-msg
```
Edit commit-msg to better fit your commit regex pattern and error message.
#### Run with NPM
Also you can add scripts into your `"scripts"` block of the `package.json` to install/uninstall hooks using `npm run <script_name>`. If you want to install hooks automatically after installing your project you can specify `"postinstall"`:
```javascript
{
  ...
  "scripts": {
    "postinstall": "npm run hooks-install",
    "hooks-install": "node common/hooks/install.js",
    "hooks-uninstall": "node common/hooks/uninstall.js"
  }
  ...
}
```
### Todos
 - add check which determines if hooks exist before removal
 - add pre-commit hook to run tests
 - try to use symbolic links in future
 - figure out how to execute many actions after hook will be triggered and separate this actions into multiple files
