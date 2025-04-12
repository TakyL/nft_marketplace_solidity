Crée par [Thomas LEDUC](https://github.com/TakyL)
# Principe

Le principe de ce projet est de pouvoir certifier de manière simple les chansons d'un auteur au sein de la blockchain. Pour ce faire,  2 contrats ont été déployés.

Un contrat [nft](https://polygonscan.com/address/0xA7F2Be4e39Cb23F8a60a4E0C5408CA2570dC405d) qui permet d'enrengistrer les titres de chansons de manière garantie dans la blockchain. Bien que le titre d'une chanson ne suffit pas pour garantir un id fiable (risque de collision, i.e : deux chansons ayant le même titre). Chaque NFT a pour id le titre de la chanson haché en SHA-3 et comme titre le titre non haché. 

Un contrat [marketplace](https://polygonscan.com/address/0xBC3911AbCe626aBF7389c8781aC2b3f1D71DD257) qui gère l'ajout et la suppression des NFT d'un utilisateur ayant un wallet en POL. CHaque ajout demande une taxe à hauteur de 0.05 gwei. Si l'utilisateur envoie plus que gwei que la taxe définie, il est alors rembourser de l'écart entre la valeur de la taxe et ce qu'il a envoyé. La suppression d'un NFT ne requiert aucun cout. 

Le code source de l'application réalisé sous Java est [ici](https://github.com/TakyL/nft_marketplace_java)
