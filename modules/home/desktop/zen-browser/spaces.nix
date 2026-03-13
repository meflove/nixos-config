rec {
  theme = {
    type = "gradient";
    colors = [
      {
        red = 92;
        green = 70;
        blue = 134;
        algorithm = "floating";
        type = "explicit-lightness";
      }
      {
        red = 135;
        green = 69;
        blue = 124;
        algorithm = "floating";
        type = "explicit-lightness";
      }
      {
        red = 135;
        green = 69;
        blue = 69;
        algorithm = "floating";
        type = "explicit-lightness";
      }
    ];
    opacity = 0.5;
    texture = 0.55;
  };

  spaces = {
    "Main" = {
      id = "65713d79-734c-4212-a94c-9c7f0124180e";
      icon = "chrome://browser/skin/zen-icons/selectable/heart.svg";
      position = 1000;
      inherit theme;
    };
    "Learning" = {
      id = "6076c1c4-e921-4cbd-a23e-4842ee89a932";
      icon = "chrome://browser/skin/zen-icons/selectable/book.svg";
      position = 2000;
      inherit theme;
    };
    "typecript" = {
      id = "d1c8e5b7-9a3e-4c8b-9f0e-2f1a5b6c7d8e";
      icon = "chrome://browser/skin/zen-icons/selectable/code.svg";
      position = 3000;
      inherit theme;
    };
    "rs2fa" = {
      id = "8a0a3c54-46e4-4978-a4c2-2fe2df211c7a";
      icon = "chrome://browser/skin/zen-icons/selectable/terminal.svg";
      position = 4000;
      inherit theme;
    };
  };
  pins = {
    # Essentials
    "icloud" = {
      id = "00ecaaed-503d-4945-b4b0-83809218c5ca";
      workspace = spaces."Main".id;
      url = "https://www.icloud.com/mail/";
      isEssential = true;
      position = 101;
    };
    "gemini" = {
      id = "909badfe-70c0-4500-8f81-7c2cba1b5f48";
      workspace = spaces."Main".id;
      url = "https://gemini.google.com";
      isEssential = true;
      position = 102;
    };
    # Main space
    "reddit" = {
      id = "e065db26-1d3f-4490-b0d7-179bd7888234";
      workspace = spaces."Main".id;
      url = "https://www.reddit.com";
      isEssential = false;
      position = 103;
    };
    "youtube" = {
      id = "162480ce-c6f5-4e29-98e2-b3c33403c3c2";
      workspace = spaces."Main".id;
      url = "https://www.youtube.com";
      isEssential = false;
      position = 104;
    };
    ## Hostoff folder
    "Hostoff" = {
      id = "0610dad3-b4b9-4908-b308-4d8fc7c32f86";
      workspace = spaces."Main".id;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      position = 105;
    };
    "amneziawg" = {
      id = "131b372b-cb90-4e49-b66f-d1b00a45d3b1";
      workspace = spaces."Main".id;
      folderParentId = pins."Hostoff".id;
      url = "https://angeldust.mooo.com/amnezia/";
      position = 106;
    };
    "3xui" = {
      id = "78f29e48-8795-434d-8d46-30fa5c9e512c";
      workspace = spaces."Main".id;
      folderParentId = pins."Hostoff".id;
      url = "https://angeldust.mooo.com/G0o4omNdaB/panel";
      position = 107;
    };
    "hostoff-panel" = {
      id = "a5ac318e-6fca-4356-92f3-2181576a138c";
      workspace = spaces."Main".id;
      folderParentId = pins."Hostoff".id;
      url = "https://panel.hostoff.net/services/virtual-servers";
      position = 108;
    };
    # Learning space
    "google-docs" = {
      id = "103a48bb-762d-494d-8081-0574a90b7069";
      workspace = spaces."Learning".id;
      url = "https://docs.google.com";
      isEssential = false;
      position = 200;
    };
    "asu-timetable" = {
      id = "0ed210c7-e175-4059-a7bc-812e3d4bb6b7";
      workspace = spaces."Learning".id;
      url = "https://www.asu.ru/timetable/students/15/2129441278/";
      isEssential = false;
      position = 201;
    };
    "asu-portal" = {
      id = "5b67d15b-da88-4bb1-a156-97d6b293061e";
      workspace = spaces."Learning".id;
      url = "https://portal.edu.asu.ru";
      isEssential = false;
      position = 202;
    };
    # rs2fa space
    ## learning folder
    "learn" = {
      id = "1172cd7f-5099-4066-8493-4fecbd70da4a";
      workspace = spaces."rs2fa".id;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      position = 400;
    };
    "rustlings" = {
      id = "cd98485a-aa6c-4f6c-a7c4-1cda2708f843";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."learn".id;
      url = "https://rustlings.rust-lang.org/";
      position = 401;
    };
    "rust-doc" = {
      id = "d1f61857-d870-4205-935f-7b9f66c35759";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."learn".id;
      url = "https://doc.rust-lang.org/stable/reference/";
      position = 402;
    };
    "rust-book" = {
      id = "0e4ea69f-ec18-4bd1-86f1-965489e2b4a0";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."learn".id;
      url = "https://rust-book.cs.brown.edu/experiment-intro.html";
      position = 403;
    };
    "rust-by-example" = {
      id = "9e336f8b-3f91-4593-87ae-bec80f04fbd7";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."learn".id;
      url = "https://doc.rust-lang.ru/stable/rust-by-example/index.html";
      position = 404;
    };
    ## libs folder
    "libs" = {
      id = "77acce3e-d14e-47f7-b2e3-d67cbff3e074";
      workspace = spaces."rs2fa".id;
      isGroup = true;
      isFolderCollapsed = true;
      editedTitle = true;
      position = 500;
    };
    "libreauth" = {
      id = "8a58525e-9b1c-4efb-b473-b74af08027d2";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."libs".id;
      url = "https://github.com/breard-r/libreauth";
      position = 501;
    };
    "totp-rs" = {
      id = "6c67a1a6-bb3b-4d6e-ac5b-d12b363b1701";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."libs".id;
      url = "https://github.com/constantoine/totp-rs";
      position = 502;
    };
    "totp-rs-crates" = {
      id = "24229e22-090f-480a-a36b-87cf18b20609";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."libs".id;
      url = "https://crates.io/crates/totp-rs";
      position = 503;
    };
    "awesome-ratatui" = {
      id = "42f54675-5eaf-4ddb-ad54-0126088d8c60";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."libs".id;
      url = "https://github.com/ratatui/awesome-ratatui";
      position = 504;
    };
    "ratatui" = {
      id = "d1625072-e33f-4079-8643-1217baab0eb0";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."libs".id;
      url = "https://github.com/ratatui/ratatui/";
      position = 505;
    };
    "hello-ratatui" = {
      id = "070bceb7-7dda-45b8-a3c6-f75935614503";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."libs".id;
      url = "https://ratatui.rs/tutorials/hello-ratatui/";
      position = 506;
    };
    "tui-input" = {
      id = "35e6e22d-d114-426f-b450-96181770543f";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."libs".id;
      url = "https://github.com/sayanarijit/tui-input/blob/main/examples/crossterm_input.rs";
      position = 507;
    };
    "terminput" = {
      id = "fb842da8-2a20-4eab-9256-6a520603691c";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."libs".id;
      url = "https://crates.io/crates/terminput";
      position = 508;
    };
    "rusqlite" = {
      id = "44971ba2-9f73-4305-acfa-b4cbe71e153f";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."libs".id;
      url = "https://github.com/rusqlite/rusqlite";
      position = 509;
    };
    "native-db" = {
      id = "ba8455e4-05fb-471c-8224-1c98e01c3dd2";
      workspace = spaces."rs2fa".id;
      folderParentId = pins."libs".id;
      url = "https://docs.rs/native_db/latest/native_db/#quick_start";
      position = 510;
    };
  };
}
