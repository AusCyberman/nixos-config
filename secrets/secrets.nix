let auscyber = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILeCdR16VYTNmoEekYk/b1sskC+trPx9tpOBJoKML17H willp@outlook.com.au";
in
  {
    "spotify_api.age".publicKeys = [ auscyber];
  }
