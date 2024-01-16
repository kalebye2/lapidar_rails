class BasePdf < Prawn::Document
  include ApplicationHelper
  def initialize(model = nil, page_size: 'A4', margin: [50, 100, 140, 200])
    super(page_size: page_size)
    font_families.update(
    "Tex Gyre Adventor" => {
      normal: Rails.root.join("public/assets/fonts/texgyreadventor-regular.otf"),
      bold: Rails.root.join("public/assets/fonts/texgyreadventor-bold.otf")
    },

    "Linux Biolinum O" => {
      normal: Rails.root.join("public/assets/fonts/LinBiolinum_R.otf"),
      bold: Rails.root.join("public/assets/fonts/LinBiolinum_RB.otf")
    },

    "Linux Libertine" => {
      normal: Rails.root.join("public/assets/fonts/LinLibertine_R.otf"),
      bold: Rails.root.join("public/assets/fonts/LinLibertine_RB.otf"),
    },
  )

    @heading_font = "Helvetica"
    @body_font = "Helvetica"

    @page_num_options = {
      align: :center,
      at: [0,0]
    }
  end
end
