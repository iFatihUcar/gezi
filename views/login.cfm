<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gezi Onay Sistemi - Giriş</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
        }
        body {
            display: flex;
            align-items: center;
            padding-top: 40px;
            padding-bottom: 40px;
            background-color: #f5f5f5;
        }
        .form-signin {
            width: 100%;
            max-width: 330px;
            padding: 15px;
            margin: auto;
        }
        .form-signin .form-floating:focus-within {
            z-index: 2;
        }
        .form-signin input[type="text"] {
            margin-bottom: -1px;
            border-bottom-right-radius: 0;
            border-bottom-left-radius: 0;
        }
        .form-signin input[type="password"] {
            margin-bottom: 10px;
            border-top-left-radius: 0;
            border-top-right-radius: 0;
        }
    </style>
</head>
<body class="text-center">
    <main class="form-signin">
        <form action="index.cfm?action=doLogin" method="post">
            <h1 class="h3 mb-3 fw-normal">Gezi Onay Sistemi</h1>
            
            <cfif IsDefined("url.error") AND url.error EQ 1>
                <div class="alert alert-danger">
                    Kullanıcı adı veya şifre hatalı!
                </div>
            </cfif>
            
            <div class="form-floating">
                <input type="text" class="form-control" id="username" name="username" placeholder="Kullanıcı Adı" required>
                <label for="username">Kullanıcı Adı</label>
            </div>
            <div class="form-floating">
                <input type="password" class="form-control" id="password" name="password" placeholder="Şifre" required>
                <label for="password">Şifre</label>
            </div>
            
            <button class="w-100 btn btn-lg btn-primary" type="submit">Giriş</button>
            <p class="mt-5 mb-3 text-muted">&copy; 2025 Gezi Onay Sistemi</p>
            
        </form>
    </main>
</body>
</html>