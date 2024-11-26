# Introdução {#introducao}

Lapidar é uma aplicação de gerenciamento de dados clínicos.
Nela é possível cadastrar
[pessoas](#cadastros),
[profissionais](#profissionais),
[usuários](#usuarios),
[acompanhamentos profissionais](#acompanhamentos),
[atendimentos](#atendimentos),
[transações financeiras](#financeiro),
[devolutivas](#devolutivas),
anamneses --- [infantojuvenis](#anamneses-infantojuvenis) e [adultas](#anamneses-adultas),
gerar modelos de documentos
e gerenciar a [biblioteca](#biblioteca) da clínica.
Outras funções ainda estão em desenvolvimento
e podem ser verificadas
[na página do Github do projeto](https://github.com/kalebye2/lapidar_rails).

Há dois modos de utilizar a aplicação: o modo visitante e o modo profissional.

## Modo Visitante

A pessoa pode verificar a agenda de hoje da clínica,
bem como verificar os profissionais da clínica e pegar suas informações
de contato.
Ela também pode ver o catálogo na [biblioteca](#biblioteca) da clínica
caso tenha interesse em ler algum material disponível
(só é possível se a configuração tiver habilitado o acesso à biblioteca).

## Modo Profissional
A pessoa terá funções dentro da aplicação de acordo com o papel atribuído a ela,
podendo ser
[administrador](#administrador),
[corpo clínico](#corpo-clínico),
[secretário](#secretário),
[financeiro](#papel-financeiro)
e [suporte de TI](#suporte-de-ti).
Cada um desses papéis será melhor detalhado na seção
[Papéis](#papeis).

# Papéis {#papeis}

## Administrador

É o que tem o maior acesso na aplicação.
Todas as funções atribuídas aos outros papéis são atribuídas a ele.
Deve ser utilizado somente por quem, de fato, precisa ter acesso a
todas as funcionalidades da aplicação.
Caso a pessoa seja responsável apenas pela administração da parte técnica
é melhor ser atribuído o papel [Suporte de TI](#suporte-de-ti),
que é limitado a estas questões.

## Corpo Clínico {#corpo-clinico}

Para quem faz parte do corpo clínico.
É capaz de
fazer cadastros,
gerenciar seus acompanhamentos e atendimentos,
fazer gerenciamento de sua parte financeira,
acessar e preparar laudos e anamneses
e escrever suas próprias devolutivas.
O acesso à edição e criação de todas estas partes é limitada
ao que o usuário possui e ele não pode editar ou criar
nada para outro usuário.

## Secretaria

O secretário possui acesso a todos os itens da agenda
de todos os profissionais cadastrados.
Limitado ao gerenciamento de agenda e cadastros na aplicação.

## Financeiro {#papel-financeiro}

O usuário com este papel terá acesso a todos os registros
financeiros dentro da aplicação para criação, edição ou exclusão.

## Suporte de TI

O suporte de TI é o papel para aqueles que terão acesso
às partes técnicas da aplicação.
Eles terão acesso aos dados de acompanhamentos, atendimentos e cadastros,
mas não poderão criar, editar ou excluir nenhum desses registros.
No entanto, partes mais técnicas da aplicação
como registro das diferentes informações secundárias
(ver seção [informações secundárias](#informacoes-secundarias))
e ajuste de dados ou informações dos usuários da aplicação.

# Cadastros

Os cadastros são os registros de todos aqueles que passam pela clínica ---
usuários dos serviços e prestadores de serviços.
Na criação ou edição dos cadastros são solicitados os dados pessoais,
que serão utilizados por toda a aplicação.
**O cadastro é a unidade mínima de registro,
pois é necessário para qualquer outro registro existente na plataforma
exceto os da [Biblioteca](#biblioteca).**

Quando se escolhe um cadastro, o sistema puxa todos os dados
existentes daquele cadastro para visualização ---
dados pessoais, prontuário, anamneses e laudos.
Se o cadastro também pertencer a um profissional
será possível verificar todos os casos pelos quais é responsável.

Cada cadastro corresponde a uma única pessoa,
portanto não é necessário realizar mais de um cadastro
para cada pessoa que passar pela clínica.
As informações de cadastro que podem ser registradas são:

- Nome, nome do meio e sobrenome (separados para facilitar leitura)
- Nome social (se tiver)
- CPF
- RG
- Telefone: Código do país, código de área e número de telefone
- Sexo
- Estado civil
- Grau de instrução
- Data de nascimento
- Cidade natal
- Estado natal
- País de origem
- E-mail (obrigatório, caso não exista o padrão será "nao@informado.com"
- Endereço completo (país, estado, cidade, bairro, CEP, logradouro e complemento)
- Profissão
- Preferência de contato
- Pronome de tratamento
- Inverter pronome (para indivíduos transexuais)
- Quais meios de mensagem rápida utiliza (Whatsapp ou Telegram)
- Breve biografia

Na página do cadastro é possível verificar essas informações e registrar
quais cadastros pertencem a parentes (ou contatos de referência)
e medicações importantes de serem registradas.
Também estará disponível para o usuário
baixar o prontuário da pessoa cadastrada,
baixar o modelo de pasta zipada para colocar arquivos
que serão deixados na própria máquina
(como relatos de sessão e outros documentos
específicos do profissional)
e a ficha cadastral para baixar
(que pode ser bem útil para imprimir e colocar na pasta
de prontuário físico da pessoa).

Os cadastros podem ser editados por usuários que possuam os papéis de
*administrador*, *corpo clínico* e *secretaria*.

# Profissionais

Assim que for registrado o cadastro,
é possível registrar um profissional na plataforma que atenda ao cadastro realizado.
Nesta página é possível
Na página do profissional estarão disponíveis todos os
atendimentos futuros e acompanhamentos pelos quais responde,
bem como a agenda disponível e os modelos de contrato
que ele registrou para seus acompanhamentos.

O profissional obrigatoriamente está associado a um cadastro na clínica
e pode ser associado a um usuário da aplicação.
**Para ser usuário da aplicação
é necessário que primeiramente seja registrado como profissional**.

O registro do profissional tem as seguintes opções:

- Cadastro ao qual faz parte
- Função
- Região do documento
- Número do registro do documento (dos conselhos regionais, por exemplo)
- 2 Chaves PIX
- Breve biografia profissional ---
que é diferente da biografia do cadastro
e só aparece na área do profissional.

Na página do profissional é possível registrar
novos horários para a agenda.

Na página da agenda é possível tanto
atualizar a agenda com novos horários
quanto retirar horários antes disponibilizados.

## Profissionais usuários da aplicação

Cada vez que um profissional é registrado
é possível que ele tenha um usuário cadastrado
para acessar os dados da aplicação.
Esta é uma funcionalidade específica para profissionais cadastrados
por motivo de segurança
e podem ser alterados em futuras atualizações da aplicação.
O usuário é criado por um [administrador](#administrador) da aplicação
ou um [suporte de TI](#suporte-de-ti).

# Acompanhamentos

Nesta seção é possível ver todos os acompanhamentos profissionais ---
tanto os que estão em curso quando os finalizados ---
com as informações principais sobre seu andamento,
qual o tipo de acompanhamento e profissional responsável,
quando foi o início etc.
Nele também é possível verificar os dados
dos atendimentos dele, bem como baixar um prontuário em formato Markdown
caso o usuário seja do [corpo clínico](#corpo-clinico) e responsável pelo caso
ou da [secretaria](#secretaria).

Para cada acompanhamento é possível registrar:

- A plataforma de início do acompanhamento
(para casos nos quais o acompanhamento
precisa ser registrado a uma plataforma online
ou em uma plataforma que a clínica utilize, por exemplo)
- Se o acompanhamento é de um menor de idade
- O motivo do acompanhamento
- O responsável legal pelo acompanhamento
- A data inicial do acompanhamento
- O motivo de finalização do acompanhamento (se houver)
- O valor da sessão
(no momento da criação estará como
"valor no contrato")
- A frequência de sessões mensais
(considerando 4 semanas = 1 mês;
no momento da criação também registra
a frequência de sessões a colocar no contrato)
- O valor das sessões no contrato
- A frequência das sessões no contrato
- A hipótese diagnóstica
- O objetivo do acompanhamento
- O prognóstico do acompanhamento

Na página do acompanhamento
tem-se a opção de baixar a declaração,
confeccionar um contrato,
baixar o prontuário
e verificar as informações financeiras
caso o usuário tenha a função
*financeiro*.
Também é possível
registrar e excluir horários,
declarar como suspenso
e consultar os atendimentos.

# Financeiro

Nesta parte o acesso é permitido apenas para quem tem acesso
financeiro na clínica --- perfis administradores e financeiros.
Nela é possível acessar os dados para
[valores de atendimentos](#valores-de-atendimentos),
[recebimentos](#recebimentos),
[gastos](#gastos),
[repasses](#repasses) e
[reajustes](#reajustes) realizados pelos profissionais.

Para toda operação financeira é possível
baixar relatórios nos formatos
CSV e Excel, que são formatos bastante utilizados
por departamentos financeiros e facilitam
alguns registros e análises por parte de economistas
e contadores.

## Valores de atendimentos

Aqui o profissional tem acesso aos valores
de cada atendimento realizado na clínica.
Se for um profissional responsável pelo
[financeiro](#financeiro)
o acesso é liberado para todas as operações
financeiras registradas na aplicação;
caso seja do [corpo clínico](#corpo-clinico) terá acesso apenas
às operações que acompanha.

Os valores de atendimentos não são registrados na parte financeira,
mas apenas na seção do **acompanhamento** do qual faz parte.
No acesso ao acompanhamento, tanto quem é
[corpo clínico](#corpo-clinico)
e é o profissional responsável pelo acompanhamento
como quem é [financeiro](#financeiro)
ou da [secretaria](#secretaria)
tem a opção de gerar um valor de atendimento pro atendimento
ou editar o que já está ali.

As informações de cada valor são:

- Valor (em R$)
- Desconto (em R$)
- Taxa externa (em %), que representa a taxa
que seria paga numa plataforma externa, por exemplo
- Taxa interna (em %), que representa a taxa
que o profissional deve à clínica

## Recebimentos

Registro dos valores recebidos na clínica.
Estes registros *não* substituem o registro fiscal
que a clínica fica responsável por realizar normalmente,
é apenas um registro para controle interno.
São registros que *auxiliam* a clínica na elaboração
de documentos fiscais como *recibos*,
que podem ser baixados para cada um dos recebimentos registrados
nos formatos [Markdown](#markdown) e PDF.

Um recebimento possui os seguintes atributos:

- Acompanhamento para o qual o recebimento será registrado
- Pagante
- Data de recebimento
- Valor (em R$)
- A modalidade de pagamento

## Gastos

A opção de registrar gastos será implementada
em atualização posterior da aplicação.

## Repasses

Aqui são registrados os repasses que a clínica faz aos profissionais.
Só ficam disponíveis caso a aplicação esteja configurada
para registrar repasses,
considerando que a clínica pode receber diretamente os valores
e então repassar para os profissionais.
Neste caso,
quando um recebimento é registrado com a opção
*direto para o profissional* assinalada automaticamente se registra
um repasse ao profissional daquele acompanhamento.
Assim a clínica pode declarar o valor repassado ao profissional
caso tenha um sistema unificado de recebimentos
ou necessite informar a outrem sobre os repasses que realiza,
bem como facilitar o acesso à informação financeira
da clínica.

## Reajustes

Reajustes são alterações nos valores dos atendimentos
registradas pelos profissionais
após um acompanhamento ter iniciado.
Digamos que um acompanhamento tenha iniciado
com cada sessão custando R$ 100
e, em um ano,
houve um reajuste de R$ 110 por sessão para aquele acompanhamento;
neste caso, o profissional registra nesta seção da aplicação.

Para registrar um reajuste para um acompanhamento,
o profissional tem a opção de definir os seguintes atributos:

- Acompanhamento ao qual o reajuste será efetuado
- Data do reajuste (quando vai ser aplicado)
- Valor negociado (em R$)
- Data da negociação (quando o paciente foi informado do reajuste)
- Motivo do reajuste

# Documentos

Nesta parte os profissionais podem
elaborar os documentos importantes para uso na aplicação como
[laudos](#laudos),
[devolutivas](#devolutivas),
[anamneses](#anamneses) e
[modelos de contrato](#modelos-de-contrato).
Em breve será também implementada
a possibilidade de geração de relatórios multiprofissionais
para cada paciente.

É importante ressaltar que os documentos aqui registrados
*não substituem nenhum dos documentos oficiais dos profissionais*
e esta parte está aqui para melhor *compartilhamento* dos mesmos
entre os integrantes da clínica.
Mesmo se permitíssemos um sistema de assinatura digital
ainda assim é necessário que o profissional
faça o seu documento dentro dos padrões estabelecidos.
Eles ficam aqui registrados para melhorar a pesquisa
e facilitar o acesso de outros profissionais às informações
relatadas pelo profissional a respeito de um determinado paciente.

Exclusivamente nesta parte de documentos
existe um padrão para a inclusão de dados relacionados ao documento
se utilizando de [*templates*](#templates).

## Laudos

O registro de laudos aqui existe para que haja
facilidade na pesquisa de outros profissionais.
*Estes registros não substituem o documento oficial do profissional*.
Eles ficam ali registrados para pesquisa e download
de quem tenha interesse, podendo ser baixados em [Markdown](#markdown) ou PDF
para que o profissional responsável possa elaborar o seu documento oficial.

Um laudo só pode ser editado e fechado
pelo profissional responsável pelo acompanhamento registrado.
**Um profissional só pode registrar um laudo
para os acompanhamentos
nos quais é o profissional responsável**.

Para o laudo, os atributos editáveis são:

- Acompanhamento
- Data da avaliação
- Interessado
- Finalidade da avaliação
- Demanda
- Técnicas utilizadas
- Análise
- Conclusão
- Referências
- Se está aberto ou fechado

Quando o laudo está fechado, nenhuma opção fica disponível
para edição e ele fica com o cadeado fechado
para sinalizar ao profissional responsável
e aos outros profissionais
que o laudo está completado e pode ser usado como referência.
Quando o laudo está aberto
ele é sinalizado com um cadeado aberto
para que todos vejam que o laudo não pode ser usado como referência.
No momento da edição,
no formato de tabela,
clicar em cima do texto abre a edição do mesmo.

**Importante**:
Os instrumentos usados numa avaliação
**devem ser registrados junto aos atendimentos**.
A aplicação reconhece os instrumentos utilizados no acompanhamento
e já os sinaliza quando o acompanhamento for escolhido para o laudo.

## Devolutivas

Registro das devolutivas do profissional
aos seus pacientes.
Os atributos editáveis são:

- Sobre quem?
- Com quem?
- Profissional
- Data
- Pontos a abordar
- Feedback de quem está recebendo a devolutiva
- Orientações do profissional

## Anamneses

As anamneses estão separadas em
[anamneses infantojuvens](#anamneses-infantojuvenis)
e [anamneses adultas](#anamneses-adultas).
Aqui o profissional registra uma anamnese
para um dos atendimentos que ele tenha realizado.
O atendimento precisa ter sido registrado
com o tipo *ANAMNESE* para aparecer
na lista de atendimentos de registro.

Quando registrar a anamnese
o profissional pode registrar alguns dados pessoais
do paciente como a *data de nascimento* e o *sexo*.
Outros dados pessoais devem ser registrados na parte de
[cadastros](#cadastros).

Anamneses são documentos completos,
portanto é importante que os profissionais
estejam bem atentos às informações que vão colocar nelas.

### Anamneses infantojuvenis

As anamneses infantojuvenis podem ser registradas
para atendimentos de anamnese de pacientes
em acompanhamento que foi registrado como infantojuvenil
ou cujo paciente tenha menos de 18 anos.
Para a anamnese infantojuvenil,
primeiro é necessário registrar:

- A pessoa de quem se faz a anamnese
- O responsável
- O tipo de acompanhamento
- A data da anamnese

Depois de criada a anamnese,
será dada uma vasta lista de itens
pro profissional registrar da criança ou adolescente
que está sendo submetido à anamnese.

### Anamneses adultas

Estas anamneses podem ser registradas
para atendimentos de anamnese de pacientes
cujo acompanhamento não foi registrado como infantojuvenil
ou que tenham 18 anos de idade ou mais.

Os atributos editáveis são:

- Pessoa submetida à anamnese
- Data
- Serviço procurado
- Responsável
- Motivo da consulta
- Anos de escolaridade
- Quem encaminhou
- Históricos
	- Profissional
	- Ocupacional
	- Médico
	- Antecedentes familiares
	- Desenvolvimento neuropsicomotor
- Condição atual
	- Aspectos psicoemocionais
	- Aspectos psicossociais
	- Comorbidades
	- Medicações em uso
	- Se faz ou fez uso de drogas ilícitas
	- Se possui autonomia nas atividades diárias
	- Alimentação
	- Sono
	- Habilidades afetadas
	- Motivo do encaminhamento
- Anotações do profissional
	- Diagnóstico preliminar
	- Plano de tratamento
	- Prognóstico

### Modelos de contrato

Cada profissional terá seus modelos de contrato
para os acompanhamentos.
Todo modelo de contrato tem:

- Título (o que vai aparecer no documento para o paciente)
- Descrição (para o profissional identificar melhor)
- Conteúdo

## Templates

Os templates são partes que possuem *tokens* específicos
que os permite serem substituídos por informações relacionadas ao documento.
Todas as opções mencionadas aqui
devem ser colocadas entre `{%` e `%}`
e a aplicação irá renderizar o documento
com a informação solicitada pelo template.
Ex.:

> Considerando isto, vemos que
{% pessoa.nome\_completo %}
possui dificuldades na aprendizagem
devido ao seu quadro disléxico.

Se o nome completo do paciente for Mateus Borges Ribeiro,
a aplicação vai renderizar o template assim:

> Considerando isto, vemos que
Mateus Borges Ribeiro
possui dificuldades na aprendizagem
devido ao seu quadro disléxico.

Abaixo estão as opções dos templates
(como uma *cheat sheet*):

- Opções para pessoa
	- pessoa
	- paciente
	- cliente

- Opções para pessoa nome completo
	- pessoa.nome\_completo
	- paciente.nome\_completo
	- cliente.nome\_completo
	- nome completo do paciente
	- nome completo do cliente
	- nome\_completo\_pessoa
	- nome\_completo\_paciente
	- nome\_completo\_cliente

- Opções para responsavel
	- responsavel
	- responsável
	- responsável legal
	- pessoa responsável

- Opções para responsavel nome completo
	- responsavel.nome\_completo
	- nome completo do responsável
	- nome completo do responsavel
	- nome completo do responsável legal
	- nome\_completo\_responsavel

- Opções para profissional nome completo
	- profissional\_nome \_completo
	- profissional.nome\_completo
	- nome completo do profissional
	- profissional

- Opções para profissional descricao completa
	- profissional\_descricao\_completa
	- profissional.descricao\_completa 
	- descrição completa do profissional

- Opções para profissional documento
	- profissional.documento
\ t- profissional\_documento
	- documento do profissional

- Opções para profissional documento tipo
	- profissional.documento\_tipo
	- profissional\_documento\_t ipo
	- pro\_documento\_tipo

- Opções para profissional documento valor
	- profissional.documento\_valor
	- profissional\_documento
	- pro\_doc\_valor
	- pro\_documento\_valor

- Opções para profissional documento re giao
	- profissional.documento\_regiao
	- profissional\_documento\_regiao
	- pro\_doc\_regiao
	- pro\_do cumento\_regiao

- Opções para profissional email
	- profissional.email
	- pro\_email

- Opções para profissional fone
	- profissional.fone
	- pro\_fone

- Opções para profissional fone link
	- profissional.fone\_link
	- pro\_fone\_link

- Opções para profissional pix
	- profissional.chave\_pix
	- pro\_pix

- Opções para data inicio
	- data\_inicio
	- data de início
	- data início
	- início data
	- inicio\_data
	- quando começou
	- quando\_comecou

- Opções para data inicio extenso
	- data\_inicio\_extenso
	- acompanhamento.data\_inicio\_por\_extenso
	- data de início do acompanhamento por extenso
	- data\_inicio.extenso

- Opções para valor sessao contrato
	- valor\_sessoes
	- valor das sessões
	- valor da sessão

- Opções para num sessoes
	- num\_sessoes
	- número de sessões
	- sessões

# Markdown

Todas as anotações em textos longos são processadas no formato Markdown,
que é um formato de marcação de texto simples com foco em praticidade.
Caso queira saber mais você pode ver
[este guia básico da Pipz Academy](https://docs.pipz.com/central-de-ajuda/learning-center/guia-basico-de-markdown#open)
ou ver [este guia mais detalhado de Markdown (em inglês)](https://markdownguide.org).
Tem também
[este artigo da Alura explicando como trabalhar com esta linguagem de Markup](https://www.alura.com.br/artigos/como-trabalhar-com-markdown).
Este formato foi escolhido por:

1. Ser de simples formatação e fácil de aprender e usar.
1. É um formato fácil de ser convertido
para formatos mais complexos
utilizando ferramentas de conversão como [Pandoc](https://pandoc.org).
1. Utiliza menos espaço em disco que formatos convencionais
como HTML ou XML enquanto oferece opções
de tornar o texto rico em formatação através da conversão.

É importante se familiarizar com este formato,
bem como é indicado utilizar a ferramenta de conversão
[Pandoc](https://pandoc.org) para os documentos baixados
pela aplicação na versão Markdown como prontuários, anamneses e declarações
e convertê-los no formato que preferir.
[Pandoc](https://pandoc.org) é um conversor universal que pode converter
os arquivos baixados no formato Markdown para
PDF (utilizando [LaTeX](https://www.latex-project.org/) ou [wkhtmltopdf](https://wkhtmltopdf.org/)),
HTML (formato da web),
DOCX,
ODT,
RTF,
EPUB,
Microsoft PowerPoint,
slides Beamer,
Slidy
etc.

Todos os dados que podem ser registrados em texto com possibilidade de parágrafos
seguirão esta convenção.
Inclusive este texto de ajuda foi escrito em Markdown
e convertido dentro da aplicação para o formato de visualização da web.

# Biblioteca

Será implementada em breve.
