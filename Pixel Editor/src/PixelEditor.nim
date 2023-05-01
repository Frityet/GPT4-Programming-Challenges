import nimx/[window, view, types, context, image, file_dialog, app]
import os

type
  PixelEditor = ref object of View
    image: Image
    cellSize: int

proc createImage*(self: PixelEditor, width, height: int) =
  self.image = newImage(width, height)
  self.image.fillWithColor(color(255, 255, 255, 255))

proc drawGrid*(self: PixelEditor, ctx: Context) =
  ctx.beginPath()
  ctx.setStrokeColor(color(0, 0, 0, 50))

  for x in countup(0, self.image.width * self.cellSize, self.cellSize):
    ctx.moveTo(x, 0)
    ctx.lineTo(x, self.height)
  for y in countup(0, self.image.height * self.cellSize, self.cellSize):
    ctx.moveTo(0, y)
    ctx.lineTo(self.width, y)

  ctx.stroke()

proc onMouseDown*(self: PixelEditor, event: MouseEvent) =
  let x = event.localLocation.x div self.cellSize
  let y = event.localLocation.y div self.cellSize
  self.image.setPixel(x, y, color(0, 0, 0, 255))

proc onMouseDrag*(self: PixelEditor, event: MouseEvent) =
  self.onMouseDown(event)

proc onSave*(self: PixelEditor) =
  let filename = saveFileDialog("Save Image", "", "", [("PNG Image", "*.png")])
  if filename != "":
    self.image.savePNG(filename)

method draw(self: PixelEditor, ctx: Context) =
  ctx.drawImage(self.image, 0, 0, self.width, self.height)
  self.drawGrid(ctx)

proc newPixelEditor*(width, height, cellSize: int): PixelEditor =
  new(result)
  result.init()
  result.cellSize = cellSize
  result.createImage(width, height)

proc onExitClicked() =
  app().quit()

when isMainModule:
  let wnd = newWindow("Pixel Editor", 640, 480)

  let pixelEditor = newPixelEditor(32, 32, 20)
  pixelEditor.setFrame(wnd.bounds)
  wnd.addSubview(pixelEditor)

  let saveButton = newButton("Save")
  saveButton.setFrame(20, wnd.height - 40, 100, 30)
  saveButton.onClick = proc() = pixelEditor.onSave()
  wnd.addSubview(saveButton)

  let exitButton = newButton("Exit")
  exitButton.setFrame(140, wnd.height - 40, 100, 30)
  exitButton.onClick = onExitClicked
  wnd.addSubview(exitButton)

  wnd.makeFirstResponder(pixelEditor)
  app().run()
