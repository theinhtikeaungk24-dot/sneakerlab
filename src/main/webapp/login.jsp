<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login — SneakerLab</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: #f8f8f6;
            display: flex; min-height: 100vh;
        }

        /* LEFT PANEL */
        .left {
            flex: 1; background: #111;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            padding: 60px; position: relative; overflow: hidden;
        }
        .left-bg {
            position: absolute; font-size: 200px; font-weight: 900;
            color: #1a1a1a; letter-spacing: -8px; text-transform: uppercase;
            line-height: 1; user-select: none; pointer-events: none;
        }
        .left-sneaker {
            font-size: 120px; position: relative; z-index: 2;
            animation: float 3s ease-in-out infinite;
            filter: drop-shadow(0 30px 50px rgba(255,107,43,0.3));
        }
        .left-title {
            font-size: 28px; font-weight: 900; color: #fff;
            letter-spacing: 4px; text-transform: uppercase;
            margin-top: 24px; position: relative; z-index: 2;
        }
        .left-title span { color: #FF6B2B; }
        .left-sub {
            font-size: 13px; color: #666; margin-top: 10px;
            position: relative; z-index: 2; text-align: center;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(-8deg); }
            50%       { transform: translateY(-16px) rotate(-8deg); }
        }

        /* RIGHT PANEL */
        .right {
            width: 480px; flex-shrink: 0;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            padding: 60px; background: #fff;
        }
        .form-logo { font-size: 18px; font-weight: 900; letter-spacing: 3px; color: #111; margin-bottom: 8px; }
        .form-logo span { color: #FF6B2B; }
        .form-title { font-size: 28px; font-weight: 800; color: #111; margin-bottom: 6px; }
        .form-sub { font-size: 13px; color: #aaa; margin-bottom: 36px; }

        .form-group { width: 100%; margin-bottom: 18px; }
        label { display: block; font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: #555; margin-bottom: 8px; }
        input {
            width: 100%; padding: 13px 16px;
            border: 1.5px solid #e8e8e8; border-radius: 2px;
            font-size: 14px; font-family: 'Inter', sans-serif;
            color: #111; background: #fff; transition: border-color 0.2s;
        }
        input:focus { outline: none; border-color: #111; }
        input::placeholder { color: #ccc; }

        .btn-submit {
            width: 100%; padding: 15px;
            background: #111; color: #fff; border: none;
            border-radius: 2px; font-size: 12px; font-weight: 700;
            letter-spacing: 2px; text-transform: uppercase;
            cursor: pointer; margin-top: 8px; transition: background 0.2s;
        }
        .btn-submit:hover { background: #FF6B2B; }

        .error {
            width: 100%; background: #fff5f5; border: 1.5px solid #ffdddd;
            color: #e53e3e; padding: 12px 16px; border-radius: 2px;
            font-size: 13px; margin-bottom: 20px;
        }
        .link-row { margin-top: 24px; font-size: 13px; color: #aaa; }
        .link-row a { color: #FF6B2B; text-decoration: none; font-weight: 600; }
        .link-row a:hover { text-decoration: underline; }
        .divider {
            width: 100%; display: flex; align-items: center; gap: 12px;
            margin: 24px 0; color: #ddd; font-size: 12px;
        }
        .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: #eee; }
    </style>
</head>
<body>

<!-- LEFT -->
<div class="left">
    <div class="left-bg">SNKR</div>
    <div class="left-sneaker">👟</div>
    <div class="left-title">Sneaker<span>Lab</span></div>
    <div class="left-sub">Premium sneakers for every style</div>
</div>

<!-- RIGHT -->
<div class="right">
    <div class="form-logo">Sneaker<span>Lab</span></div>
    <div class="form-title">Welcome back</div>
    <div class="form-sub">Sign in to your account</div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">⚠ <%= request.getAttribute("error") %></div>
    <% } %>

    <form action="auth" method="post" style="width:100%">
        <input type="hidden" name="action" value="login">
        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" placeholder="Enter your username" required>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter your password" required>
        </div>
        <button type="submit" class="btn-submit">Sign In →</button>
    </form>

    <div class="divider">or</div>
    <div class="link-row">Don't have an account? <a href="register.jsp">Create one</a></div>
</div>

</body>
</html>
