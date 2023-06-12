class BasePdf < Prawn::Document
  def initialize(model = nil, page_size: 'A4')
    super(page_size: page_size)
    font_families.update(
    "Tex Gyre Adventor" => {
      normal: Rails.root.join("public/assets/fonts/texgyreadventor-regular.otf"),
      bold: Rails.root.join("public/assets/fonts/texgyreadventor-bold.otf")
    },

    "Linux Biolinum O" => {
      normal: Rails.root.join("public/assets/fonts/LinBiolinum_R.otf"),
      bold: Rails.root.join("public/assets/fonts/LinBiolinum_RB.otf")
    }
  )

    @heading_font = "Tex Gyre Adventor"
    @body_font = "Linux Biolinum O"

    @page_num_options = {
      align: :center,
      at: [0,0]
    }
  end
end
