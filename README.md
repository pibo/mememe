# MemeMe

Meu próximo app nativo iOS, desenvolvido como parte do Nanodegree da Udacity. Este app permite que o usuário escolha uma imagem (da câmera ou álbum) e insira textos para gerar um meme. Os memes salvos são exibidos em uma lista ou grade, divididos por abas.

### Conceitos utilizados

No desenvolvimento deste app foram aprendidos os seguintes conceitos:

* Aprofundamento do uso do Storyboard e constraints do Auto Layout
* Criação da UI utilizando apenas código
* Padrão target/action
* Utilização de vários novos `UIControls` como `UISlider` e `UISwitch`
* Conexão de Outlets e Actions criando-os primeiro em código
* Uso de ViewControllers nativos como `UIImagePickerController`, `UIActivityViewController` e `UIAlertController`
* Utilizando Segues
* Comunicação entre ViewControllers usando apenas código, Segues ou ambos
* Primeiro exemplo de app com model: Roshambo
* Uso de `protocols`
* Uso de delegates no `UITextFieldDelegate` e `UIImagePickerControllerDelegate`
* Alterar o input do `UITextField` via `textField(_:shouldChangeCharactersIn:replacementString:)`
* Utilizar `extensions` como delegates
* Utilização do `NumberFormatter`
* Match e replace usando regex
* Selecionar imagens da câmera/álbum usando `UIImagePickerController`
* Alterar a aparência do texto em um `UITextField` via `defaultTextAttributes`
* Notificações internas do app através do `NotificationCenter.default`
* Alterar a posição da view quando o teclado sobrepõe um input
* Construir uma imagem da tela usando `UIGraphicsBeginImageContext`
* Compartilhar imagens usando o `UIActivityViewController`

### Changelog

#### v2.0

* Uso do `TabBarController` para dividir os memes salvos entre `TableView` e `CollectionView`
* Vetor de memes compartilhado entre o app através do `AppDelegate`
* Uso de `TableView` com um `ViewCell` customizado
* Uso do `CollectionView` e `FlowLayout`
* Swipe para deletar um meme na `TableView`
* Tela de detalhes ao tocar em um item na lista/grade
* Possibilidade de editar um meme através da tela de detalhes
* Melhorias no editor
	* Ajustes nas constraints
	* Botão `Cancel` que fecha o editor
	* Botão `Done` que salva o meme localmente (sem a necessidade de compartilhá-lo)
	* Um único botão para selecionar imagem: se o dispositivo tiver câmera abrirá um Action Sheet para o usuário escolher de onde quer importar, senão abrirá a galeria direto
	* Tocar na imagem também abre o Action Sheet

### Instalação

Basta clonar o repositório e abrir o arquivo de projeto `MemeMe.xcodeproj`.

### Requisitos

O app foi desenvolvido com **Swift 4.2** e **Xcode 10.0**.