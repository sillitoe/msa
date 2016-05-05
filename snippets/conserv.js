/* global rootDiv */
var msa = window.msa;
var opts = {
  el: rootDiv,
  importURL: "./data/fer1.clustal",
  vis: {
    conserv: true,
  },
  conserv: {
    maxHeight: 200,
    fillColor: ['blue', '#0f0'],
    strokeColor: '#000'
  }
};
var m = new msa(opts);
//@biojs-instance=m.g
