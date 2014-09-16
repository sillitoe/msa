MenuBuilder = require "../menubuilder"
_ = require "underscore"
dom = require "../../utils/dom"

module.exports = ColorMenu = MenuBuilder.extend

  initialize: (data) ->
    @g = data.g
    @el.style.display = "inline-block"
    @listenTo @g.colorscheme, "change", ->
      @render()

  render: ->
    menuColor = @setName("Color scheme")

    colorschemes = @getColorschemes()
    for scheme in colorschemes
      @addScheme menuColor, scheme

    text = "Background"
    if @g.colorscheme.get("colorBackground")
      text = "Hide " + text
    else
      text = "Show " + text

    @addNode text, =>
      @g.colorscheme.set "colorBackground", !@g.colorscheme.get("colorBackground")

    @grey menuColor

    # TODO: make more efficient
    dom.removeAllChilds @el
    @el.appendChild @buildDOM()
    @

  addScheme: (menuColor,scheme) ->
    style = {}
    current = @g.colorscheme.get("scheme")
    if current is scheme.id
      style.backgroundColor = "#77ED80"

    @addNode scheme.name, =>
      @g.colorscheme.set "scheme", scheme.id
    ,
      style: style

  getColorschemes: ->
    schemes  = []
    schemes.push name: "Zappo", id: "zappo"
    schemes.push name: "Taylor", id: "taylor"
    schemes.push name: "Hydrophobicity", id: "hydro"
    schemes.push name: "Lesk", id: "lesk"
    schemes.push name: "Cinema", id: "cinema"
    schemes.push name: "MAE", id: "mae"
    schemes.push name: "Clustal", id: "clustal"
    schemes.push name: "Clustal2", id: "clustal2"
    schemes.push name: "Turn", id: "turn"
    schemes.push name: "Strand", id: "strand"
    schemes.push name: "Buried", id: "buried"
    schemes.push name: "Helix", id: "helix"
    schemes.push name: "Nucleotide", id: "nucleotide"
    schemes.push name: "Purine", id: "purine"
    schemes.push name: "PID", id: "pid"
    schemes.push name: "No color", id: "foo"
    schemes

  grey: (menuColor) ->
    # greys all lowercase letters
    @addNode "Grey", =>
      @g.colorscheme.set "showLowerCase", false
      @model.each (seq) ->
        residues = seq.get "seq"
        grey = []
        _.each residues, (el, index) ->
          if el is el.toLowerCase()
            grey.push index
        seq.set "grey", grey

    @addNode "Grey by threshold", =>
      threshold = prompt "Enter threshold (in percent)", 20
      threshold = threshold / 100
      maxLen = @model.getMaxLength()
      conserv = @g.columns.get("conserv")
      grey = []
      for i in [0.. maxLen - 1]
        console.log conserv[i]
        if conserv[i] < threshold
          grey.push i
      @model.each (seq) ->
        seq.set "grey", grey

    @addNode "Grey selection", =>
      maxLen = @model.getMaxLength()
      @model.each (seq) =>
        blocks = @g.selcol.getBlocksForRow(seq.get("id"),maxLen)
        seq.set "grey", blocks

    @addNode "Reset grey", =>
      @g.colorscheme.set "showLowerCase", true
      @model.each (seq) ->
        seq.set "grey", []
