CKEDITOR.editorConfig = function (config) {
  // ... other configuration ...

  // config.toolbar_mini = [
  //   ["Bold",  "Italic",  "Underline",  "Strike",  "-",  "Subscript",  "Superscript"],
  // ];
  // config.toolbar = "mini";
  config.height = '100'

  config.toolbarGroups = [
    { name: 'basicstyles'},
    { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align'] },
    { name: 'styles' },
    { name: 'colors' },
  ];

  // The default plugins included in the basic setup define some buttons that
  // are not needed in a basic editor. They are removed here.
  config.removeButtons = 'Cut,Copy,Paste,Undo,Redo,Anchor';

  // Dialog windows are also simplified.
  config.removeDialogTabs = 'link:advanced';

  config.defaultLanguage = 'es';

  // ... rest of the original config.js  ...
}