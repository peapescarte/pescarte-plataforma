import ClassicEditor from "@ckeditor/ckeditor5-build-classic";

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
  import "phoenix_html"

function renderCKEditor(hook) {
  const ids = [
    "#editor-1",
    "#editor-2",
    "#editor-3",
    "#editor-4",
    "#editor-5",
    "#editor-6",
    "#editor-7",
  ];

  const elements = ids.map(document.querySelector);

  if (!elems.every(el => el === null)) {
    for (editor in elements) {
      ClassicEditor
        .create(editor, {
          removePlugins: ["ImageUpload", "MediaEmbed"]
        })
        .catch(err => console.log(err));
    }
  }
}
