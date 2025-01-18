class ProfissionalContratoModelo < ApplicationRecord
  belongs_to :profissional
  include ActionView::Helpers

  @@opcoes_substituicao = {
    :opcoes_pessoa => ["pessoa",
                       "paciente",
                       "cliente",
    ],
    :opcoes_pessoa_nome_completo => ["pessoa.nome_completo",
                                     "paciente.nome_completo",
                                     "cliente.nome_completo",
                                     "nome completo do paciente",
                                     "nome completo do cliente",
                                     "nome_completo_pessoa",
                                     "nome_completo_paciente",
                                     "nome_completo_cliente",
    ],
    :opcoes_responsavel => ["responsavel",
                            "responsável",
                            "responsável legal",
                            "pessoa responsável"
    ],
    :opcoes_responsavel_nome_completo => ["responsavel.nome_completo",
                                          "nome completo do responsável",
                                          "nome completo do responsavel",
                                          "nome completo do responsável legal",
                                          "nome_completo_responsavel",
    ],
    :opcoes_profissional_nome_completo => ["profissional_nome_completo",
                                           "profissional.nome_completo",
                                           "nome completo do profissional",
                                           "profissional",
    ],
    :opcoes_profissional_descricao_completa => ["profissional_descricao_completa",
                                                "profissional.descricao_completa",
                                                "descrição completa do profissional",
    ],
    :opcoes_profissional_documento => ["profissional.documento",
                                       "profissional_documento",
                                       "documento do profissional",
    ],
    :opcoes_profissional_documento_tipo => ["profissional.documento_tipo",
                                            "profissional_documento_tipo",
                                            "pro_documento_tipo",
    ],
    :opcoes_profissional_documento_valor => ["profissional.documento_valor",
                                             "profissional_documento",
                                             "pro_doc_valor",
                                             "pro_documento_valor",
    ],
    :opcoes_profissional_documento_regiao => ["profissional.documento_regiao",
                                              "profissional_documento_regiao",
                                              "pro_doc_regiao",
                                              "pro_documento_regiao",
    ],
    :opcoes_profissional_email => ["profissional.email",
                                   "pro_email"
    ],
    :opcoes_profissional_fone => ["profissional.fone",
                                  "pro_fone",
    ],
    :opcoes_profissional_fone_link => ["profissional.fone_link",
                                       "pro_fone_link",
    ],
    :opcoes_profissional_pix => ["profissional.chave_pix",
                                 "pro_pix",
    ],
    :opcoes_data_inicio => ["data_inicio",
                            "data de início",
                            "data início",
                            "início data",
                            "inicio_data",
                            "quando começou",
                            "quando_comecou",
    ],
    :opcoes_data_inicio_extenso => ["data_inicio_extenso",
                                    "acompanhamento.data_inicio_por_extenso",
                                    "data de início do acompanhamento por extenso",
                                    "data_inicio.extenso",
    ],
    :opcoes_valor_sessao_contrato => ["valor_sessoes",
                               "valor das sessões",
                               "valor da sessão",
    ],
    :opcoes_num_sessoes => ["num_sessoes",
                            "número de sessões",
                            "sessões",
    ],
  }

  def teste acompanhamento=nil
    @@opcoes_substituicao.each do |o|
      # p o
    end
    acompanhamento.send("pessoa.nome_completo")
  end

  def opcoes_substituicao
    @@opcoes_substituicao
  end

  def conteudo_para_acompanhamento acompanhamento=nil
    return nil if acompanhamento.blank? || acompanhamento.class.to_s != "Acompanhamento"
    # texto_final = conteudo
    return acompanhamento.template_para_dado conteudo

    # paciente
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_pessoa].join("|"), acompanhamento.pessoa.nome_completo
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_data_inicio_extenso].join("|"), "#{acompanhamento.data_inicio.day} de #{@@meses[acompanhamento.data_inicio.month].downcase} de #{acompanhamento.data_inicio.year}"
    # # responsável
    # # profissional
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_profissional_descricao_completa].join("|"), acompanhamento.profissional.descricao_completa
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_profissional_nome_completo].join("|"), acompanhamento.profissional.nome_completo
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_profissional_documento_tipo].join("|"), acompanhamento.profissional.profissional_funcao.documento_tipo
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_profissional_documento_regiao].join("|"), acompanhamento.profissional.documento_regiao_id
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_profissional_documento_valor].join("|"), acompanhamento.profissional.documento_valor
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_profissional_email].join("|"), acompanhamento.profissional.email
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_profissional_fone].join("|"), (acompanhamento.profissional.render_fone[3..] unless acompanhamento.profissional.render_fone.nil?)
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_profissional_fone_link].join("|"), acompanhamento.profissional.render_fone_link
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_profissional_pix].join("|"), acompanhamento.profissional.chave_pix_01
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_valor_sessao_contrato].join("|"), number_to_currency(acompanhamento.valor_sessao_contrato / 100.0, unit: "R$ ", separator: ",", delimiter: ".", precision: 2)
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_responsavel].join("|"), acompanhamento.pessoa_responsavel&.nome_completo
    # texto_final = template_para_dado texto_final, @@opcoes_substituicao[:opcoes_responsavel_nome_completo].join("|"), acompanhamento.pessoa_responsavel&.nome_completo

    # texto_final
  end
  alias colocar_dados_de_acompanhamento_no_conteudo conteudo_para_acompanhamento

  private

  # def template_para_dado texto="", subst="", dado=nil
  #   texto.gsub(/{%\s*(#{subst})\s*%}/, dado.to_s)
  # end
end
