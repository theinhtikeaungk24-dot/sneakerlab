<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register — SneakerLab</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f8f8f6; display: flex; min-height: 100vh; }

        .left {
            flex: 1; background: #FF6B2B;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            padding: 60px; position: relative; overflow: hidden;
        }
        .left-bg {
            position: absolute; font-size: 180px; font-weight: 900;
            color: rgba(255,255,255,0.08); letter-spacing: -6px;
            text-transform: uppercase; user-select: none;
        }
        .left-sneaker {
            font-size: 110px; position: relative; z-index: 2;
            animation: float 3s ease-in-out infinite;
            filter: drop-shadow(0 30px 50px rgba(0,0,0,0.2));
        }
        .left-title {
            font-size: 26px; font-weight: 900; color: #fff;
            letter-spacing: 4px; text-transform: uppercase;
            margin-top: 24px; position: relative; z-index: 2;
        }
        .left-sub { font-size: 13px; color: rgba(255,255,255,0.7); margin-top: 10px; z-index: 2; text-align: center; }
        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(-8deg); }
            50%       { transform: translateY(-16px) rotate(-8deg); }
        }

        .right {
            width: 480px; flex-shrink: 0;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            padding: 60px; background: #fff;
        }
        .form-logo { font-size: 18px; font-weight: 900; letter-spacing: 3px; color: #111; margin-bottom: 8px; }
        .form-logo span { color: #FF6B2B; }
        .form-title { font-size: 28px; font-weight: 800; color: #111; margin-bottom: 6px; }
        .form-sub { font-size: 13px; color: #aaa; margin-bottom: 32px; }

        .form-group { width: 100%; margin-bottom: 16px; }
        label { display: block; font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: #555; margin-bottom: 8px; }
        input {
            width: 100%; padding: 13px 16px;
            border: 1.5px solid #e8e8e8; border-radius: 2px;
            font-size: 14px; font-family: 'Inter', sans-serif;
            color: #111; background: #fff; transition: border-color 0.2s;
        }
        input:focus { outline: none; border-color: #FF6B2B; }
        input::placeholder { color: #ccc; }

        .btn-submit {
            width: 100%; padding: 15px;
            background: #FF6B2B; color: #fff; border: none;
            border-radius: 2px; font-size: 12px; font-weight: 700;
            letter-spacing: 2px; text-transform: uppercase;
            cursor: pointer; margin-top: 8px; transition: background 0.2s;
        }
        .btn-submit:hover { background: #e55a1a; }

        .error {
            width: 100%; background: #fff5f5; border: 1.5px solid #ffdddd;
            color: #e53e3e; padding: 12px 16px; border-radius: 2px;
            font-size: 13px; margin-bottom: 20px;
        }
        .link-row { margin-top: 24px; font-size: 13px; color: #aaa; }
        .link-row a { color: #FF6B2B; text-decoration: none; font-weight: 600; }
        .divider {
            width: 100%; display: flex; align-items: center; gap: 12px;
            margin: 20px 0; color: #ddd; font-size: 12px;
        }
        .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: #eee; }
    </style>
</head>
<body>

<div class="left">
    <div class="left-bg">JOIN</div>
    <div class="left-sneaker">👟</div>
    <div class="left-title">SneakerLab</div>
    <div class="left-sub">Join thousands of sneaker enthusiasts</div>
</div>

<div class="right">
    <div class="form-logo">Sneaker<span>Lab</span></div>
    <div class="form-title">Create account</div>
    <div class="form-sub">Join us and start shopping today</div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error">⚠ <%= request.getAttribute("error") %></div>
    <% } %>

    <form action="auth" method="post" style="width:100%">
        <input type="hidden" name="action" value="register">
        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" placeholder="Choose a username" required>
        </div>
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" placeholder="Enter your email" required>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Choose a password" required>
        </div>
        <button type="submit" class="btn-submit">Create Account →</button>
    </form>

    <div class="divider">or</div>
    <div class="link-row">Already have an account? <a href="login.jsp">Sign in</a></div>
</div>

</body>
</html>
