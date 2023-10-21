## Introdução {#introducao}

Lapidar é uma aplicação de gerenciamento de dados clínicos.
Nela é possível cadastrar
usuários,
profissionais,
acompanhamentos profissionais,
atendimentos,
transações financeiras,
devolutivas,
anamneses --- infantojuvenis e adultas,
gerar modelos de documentos
e gerenciar a biblioteca da clínica.
Outras funções ainda estão em desenvolvimento
e podem ser verificadas
[na página do Github do projeto](https://github.com/kalebye2/lapidar_rails).

Há dois modos de utilizar a aplicação: o modo visitante e o modo profissional.

Modo Visitante
: A pessoa pode verificar a agenda de hoje da clínica,
bem como verificar os profissionais da clínica e pegar suas informações
de contato.
Ela também pode ver o catálogo na biblioteca da clínica
caso tenha interesse em ler algum material disponível.

Modo Profissional
: A pessoa terá funções dentro da aplicação de acordo com o papel atribuído a ela,
podendo ser
administrador,
corpo clínico,
secretário,
financeiro
e suporte de TI.
Cada um desses papéis será melhor detalhado na seção
[Papéis](#papeis)

## Papéis {#papeis}

### Administrador

É o que tem o maior acesso na aplicação.
Todas as funções atribuídas aos outros papéis são atribuídas a ele.
Deve ser utilizado somente por quem, de fato, precisa ter acesso a
todas as funcionalidades da aplicação.
Caso a pessoa seja responsável apenas pela administração da parte técnica
é melhor ser atribuído o papel [Suporte de TI](#suporte-de-ti),
que é limitado a estas questões.

### Corpo Clínico {#corpo-clinico}

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

### Secretaria

O secretário possui acesso a todos os itens da agenda
de todos os profissionais cadastrados.
Limitado ao gerenciamento de agenda e cadastros na aplicação.

### Financeiro

O usuário com este papel terá acesso a todos os registros
financeiros dentro da aplicação para criação, edição ou exclusão.

### Suporte de TI

O suporte de TI é o papel para aqueles que terão acesso
às partes técnicas da aplicação.
Eles terão acesso aos dados de acompanhamentos, atendimentos e cadastros,
mas não poderão criar, editar ou excluir nenhum desses registros.
No entanto, partes mais técnicas da aplicação
como registro das diferentes informações secundárias
(ver seção [informações secundárias](#informacoes-secundarias))
e ajuste de dados ou informações dos usuários da aplicação.

## Cadastros

Os cadastros são os registros de todos aqueles que passam pela clínica ---
usuários dos serviços e prestadores de serviços.
Na criação ou edição dos cadastros são solicitados os dados pessoais,
que serão utilizados por toda a aplicação.
O cadastro é a unidade mínima de registro,
pois é necessário para qualquer outro registro existente na plataforma
exceto os da Biblioteca.

Quando se escolhe um cadastro, o sistema puxa todos os dados
existentes daquele cadastro para visualização ---
dados pessoais, prontuário, anamneses e laudos.
Se o cadastro também pertencer a um profissional
será possível verificar todos os casos pelos quais é responsável.

## Profissionais

Assim que for registrado o cadastro,
é possível registrar um profissional na plataforma que atenda ao cadastro realizado.
Nesta página é possível
Na página do profissional estarão disponíveis todos os
atendimentos futuros e acompanhamentos pelos quais responde.

## Acompanhamentos

Nesta seção é possível ver todos os acompanhamentos profissionais ---
tanto os que estão em curso quando os finalizados ---
com as informações principais sobre seu andamento,
qual o tipo de acompanhamento e profissional responsável,
quando foi o início etc.
Nele também é possível verificar os dados
dos atendimentos dele, bem como baixar um prontuário em formato Markdown
caso o usuário seja do corpo clínico e responsável pelo caso
ou da secretaria.

## Financeiro

Dinheiro.

## Laudos

Para laudos.

## Devolutivas

Registro das devolutivas do profissional
aos seus acompanhamentos.

## Anamneses

Anamneses.


## Markdown

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
(você pode clicar [aqui](/ajuda.md) para acessar o conteúdo bruto deste texto)
e convertido dentro da aplicação para o formato de visualização da web.
