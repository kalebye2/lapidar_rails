class PessoaDevolutivaPdf < BasePdf
  def initialize(pessoa_devolutiva)
    super()
    @pessoa_devolutiva = pessoa_devolutiva
  end
end
