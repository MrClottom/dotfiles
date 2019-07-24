require([
  'nbextensions/vim_binding/vim_binding'
], function () {
  CodeMirror.Vim.map('<Space>', ':nohl')
  CodeMirror.Vim.map('<A-q>', ':q')
})
