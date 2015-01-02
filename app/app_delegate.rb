class AppDelegate
  extend IB

  outlet :tableView, NSTableView
  outlet :arrayController, NSArrayController
  outlet :button, NSButton

  FILE_TYPES = ["png"]

  def awakeFromNib
    tableView.registerForDraggedTypes([NSFilenamesPboardType])
  end

  def tableView(aView, writeRowsWithIndexes:rowIndexes, toPasteboard:pboard)
    true
  end

  def tableView(aView, validateDrop:info, proposedRow:row, proposedDropOperation:op)
    NSDragOperationEvery
  end

  def tableView(aView, acceptDrop:info, row:droppedRow, dropOperation:op)
    pbd = info.draggingPasteboard
    pbd.propertyListForType(NSFilenamesPboardType).each do |path|
      ext = File.extname(path)[1..-1].downcase
      add_item(path) if FILE_TYPES.include?(ext)
    end
    true
  end

  # actions
  def optimize(sender)
    arrayController.arrangedObjects.each do |item|
      pngquant(item['filePath'])
      update_item(item)
    end
  end

  def add(sender)
    panel = NSOpenPanel.openPanel
    panel.canChooseFiles = true
    panel.allowsMultipleSelection = true
    panel.canChooseDirectories = false
    result = panel.runModalForDirectory(NSHomeDirectory(),
                                        file:nil,
                                        types:FILE_TYPES)
    if(result == NSOKButton)
      panel.filenames.each do |path|
        add_item(path)
      end
    end
  end

  def remove(sender)
    indexes = tableView.selectedRowIndexes
    arrayController.removeObjectsAtArrangedObjectIndexes(indexes)
  end

  private

  def add_item(path)
    file = File.basename(path)
    arrayController.addObject({
      'filePath'=> path,
      'fileName' => file,
      'fileSize' => File.size(path),
    })
  end

  def update_item(item)
    arrayController.removeObject(item)
    item['fileSize'] = File.size(item['filePath'])
    arrayController.addObject(item)
  end

  def pngquant(path)
    dir = NSBundle.mainBundle.resourcePath
    system "#{dir}/pngquant --ext .png --force \"#{path}\""
  end

end
