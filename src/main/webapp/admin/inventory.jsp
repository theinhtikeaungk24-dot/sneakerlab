<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.sneaker.model.User, com.sneaker.model.Sneaker, com.sneaker.dao.SneakerDAO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp"); return;
    }
    SneakerDAO dao = new SneakerDAO();
    List<Sneaker> list = dao.getAllSneakers();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Inventory — SneakerLab Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f8f8f6; color: #111; display: flex; min-height: 100vh; }

        .sidebar { width: 240px; background: #111; min-height: 100vh; display: flex; flex-direction: column; flex-shrink: 0; }
        .sidebar-logo { padding: 28px 28px 24px; border-bottom: 1px solid #222; font-size: 18px; font-weight: 900; letter-spacing: 3px; color: #fff; }
        .sidebar-logo span { color: #FF6B2B; }
        .sidebar-badge { display: inline-block; margin-top: 6px; background: #FF6B2B; color: #fff; font-size: 9px; font-weight: 700; letter-spacing: 1.5px; padding: 3px 8px; text-transform: uppercase; }
        .sidebar-menu { flex: 1; padding: 16px 0; }
        .sidebar-menu a { display: flex; align-items: center; gap: 12px; padding: 14px 28px; color: #666; text-decoration: none; font-size: 13px; font-weight: 500; transition: all 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu a:hover { color: #fff; background: #1a1a1a; }
        .sidebar-menu a.active { color: #fff; background: #1a1a1a; border-left-color: #FF6B2B; }
        .sidebar-footer { padding: 20px 28px; border-top: 1px solid #222; }
        .sidebar-user { font-size: 12px; color: #555; margin-bottom: 10px; }
        .sidebar-user strong { color: #fff; display: block; font-size: 13px; }
        .btn-logout { display: block; width: 100%; padding: 10px; background: transparent; border: 1px solid #333; color: #666; font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; text-align: center; transition: all 0.2s; }
        .btn-logout:hover { border-color: #FF6B2B; color: #FF6B2B; }

        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { background: #fff; padding: 20px 40px; border-bottom: 1px solid #f0f0f0; display: flex; justify-content: space-between; align-items: center; }
        .topbar-title { font-size: 22px; font-weight: 800; color: #111; }
        .topbar-sub { font-size: 13px; color: #aaa; margin-top: 2px; }
        .content { padding: 32px 40px; overflow-y: auto; }

        .add-form { background: #fff; padding: 28px 32px; margin-bottom: 28px; border-top: 3px solid #FF6B2B; }
        .form-title { font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: #aaa; margin-bottom: 18px; }
        .form-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 16px; }
        .form-grid input, .form-grid select { padding: 11px 14px; border: 1.5px solid #e8e8e8; border-radius: 2px; font-size: 13px; font-family: 'Inter', sans-serif; color: #111; background: #fff; transition: border-color 0.2s; }
        .form-grid input:focus, .form-grid select:focus { outline: none; border-color: #111; }
        .form-grid input::placeholder { color: #ccc; }
        .file-upload-box {
            border: 2px dashed #e8e8e8; border-radius: 2px; padding: 20px;
            text-align: center; cursor: pointer; transition: all 0.2s;
            grid-column: 1 / -1; background: #fafafa;
        }
        .file-upload-box:hover { border-color: #FF6B2B; background: #fff8f5; }
        .file-upload-box input[type=file] { display: none; }
        .file-upload-box label { cursor: pointer; font-size: 13px; color: #aaa; }
        .file-upload-box label span { color: #FF6B2B; font-weight: 700; }
        .file-preview { margin-top: 10px; display: none; }
        .file-preview img { width: 80px; height: 80px; object-fit: cover; border-radius: 4px; }
        .btn-add { padding: 11px 28px; background: #111; color: #fff; border: none; border-radius: 2px; font-size: 11px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; }
        .btn-add:hover { background: #FF6B2B; }

        .table-wrap { background: #fff; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { border-bottom: 2px solid #f0f0f0; }
        th { padding: 14px 18px; text-align: left; font-size: 10px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; color: #aaa; }
        tbody tr { border-bottom: 1px solid #f8f8f8; transition: background 0.15s; }
        tbody tr:hover { background: #fafafa; }
        td { padding: 16px 18px; font-size: 13px; color: #333; }
        .stock-ok  { color: #22c55e; font-weight: 600; }
        .stock-low { color: #FF6B2B; font-weight: 600; }
        .stock-out { color: #ef4444; font-weight: 600; }
        .btn-edit { padding: 6px 14px; background: #111; color: #fff; border: none; border-radius: 2px; font-size: 11px; font-weight: 600; cursor: pointer; transition: background 0.2s; margin-right: 6px; }
        .btn-edit:hover { background: #FF6B2B; }
        .btn-delete { padding: 6px 14px; background: transparent; color: #ef4444; border: 1px solid #ef4444; border-radius: 2px; font-size: 11px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .btn-delete:hover { background: #ef4444; color: #fff; }
        .btn-variants { padding: 6px 14px; background: transparent; color: #FF6B2B; border: 1px solid #FF6B2B; border-radius: 2px; font-size: 11px; font-weight: 600; cursor: pointer; transition: all 0.2s; margin-right: 6px; }
        .btn-variants:hover { background: #FF6B2B; color: #fff; }

        .modal-bg { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 200; align-items: center; justify-content: center; }
        .modal-bg.show { display: flex; }
        .modal { background: #fff; width: 500px; border-top: 4px solid #FF6B2B; }
        .modal-header { padding: 24px 28px; border-bottom: 1px solid #f0f0f0; }
        .modal-title { font-size: 16px; font-weight: 800; color: #111; }
        .modal-body { padding: 28px; }
        .modal-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 20px; }
        .modal-grid input, .modal-grid select { padding: 11px 14px; border: 1.5px solid #e8e8e8; border-radius: 2px; font-size: 13px; font-family: 'Inter', sans-serif; color: #111; width: 100%; transition: border-color 0.2s; }
        .modal-grid input:focus, .modal-grid select:focus { outline: none; border-color: #111; }
        .modal-grid input::placeholder { color: #ccc; }
        .modal-footer { display: flex; gap: 10px; }
        .btn-save { flex: 1; padding: 12px; background: #111; color: #fff; border: none; border-radius: 2px; font-size: 11px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; }
        .btn-save:hover { background: #FF6B2B; }
        .btn-cancel { padding: 12px 20px; background: transparent; color: #aaa; border: 1px solid #e8e8e8; border-radius: 2px; font-size: 11px; font-weight: 700; cursor: pointer; transition: all 0.2s; }
        .btn-cancel:hover { border-color: #111; color: #111; }

        /* Variants modal */
        .vmodal { background: #fff; width: 580px; max-height: 80vh; overflow-y: auto; border-top: 4px solid #FF6B2B; }
        .variant-list { display: flex; flex-direction: column; gap: 10px; margin-bottom: 24px; min-height: 40px; }
        .variant-row {
            display: flex; align-items: center; gap: 14px;
            padding: 12px 14px; background: #fafafa; border: 1px solid #f0f0f0; border-radius: 4px;
        }
        .v-swatch { width: 32px; height: 32px; border-radius: 50%; flex-shrink: 0; border: 2px solid rgba(0,0,0,0.08); }
        .v-thumb { width: 56px; height: 56px; object-fit: contain; border-radius: 4px; background: #f0f0f0; flex-shrink: 0; }
        .v-thumb-ph { width: 56px; height: 56px; background: #f0f0f0; border-radius: 4px; display: flex; align-items: center; justify-content: center; font-size: 24px; flex-shrink: 0; }
        .v-color-name { flex: 1; font-size: 13px; font-weight: 600; color: #111; }
        .btn-vdel { padding: 5px 12px; background: transparent; color: #ef4444; border: 1px solid #ef4444; border-radius: 2px; font-size: 11px; font-weight: 600; cursor: pointer; transition: all 0.2s; flex-shrink: 0; }
        .btn-vdel:hover { background: #ef4444; color: #fff; }
        .v-add-form { border-top: 1px solid #f0f0f0; padding-top: 20px; }
        .v-add-title { font-size: 11px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; color: #aaa; margin-bottom: 14px; }
        .v-form-row { display: flex; gap: 12px; align-items: flex-start; }
        .v-color-select { flex: 1; padding: 11px 14px; border: 1.5px solid #e8e8e8; border-radius: 2px; font-size: 13px; font-family: 'Inter', sans-serif; color: #111; background: #fff; }
        .v-color-select:focus { outline: none; border-color: #FF6B2B; }
        .v-file-box {
            flex: 2; border: 2px dashed #e8e8e8; border-radius: 2px; padding: 14px;
            text-align: center; cursor: pointer; transition: all 0.2s; background: #fafafa;
        }
        .v-file-box:hover { border-color: #FF6B2B; background: #fff8f5; }
        .v-file-box input { display: none; }
        .v-file-box label { cursor: pointer; font-size: 12px; color: #aaa; }
        .v-file-box label span { color: #FF6B2B; font-weight: 700; }
        .v-preview { margin-top: 8px; display: none; }
        .v-preview img { width: 60px; height: 60px; object-fit: contain; border-radius: 4px; background:#f0f0f0; }
        .btn-vadd { padding: 11px 20px; background: #FF6B2B; color: #fff; border: none; border-radius: 2px; font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; flex-shrink: 0; align-self: flex-start; margin-top: 0; }
        .btn-vadd:hover { background: #e55a1a; }
        .v-empty { text-align: center; color: #ccc; font-size: 13px; padding: 20px 0; }
        .v-loading { text-align: center; color: #aaa; font-size: 13px; padding: 20px 0; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-logo">Sneaker<span>Lab</span><div class="sidebar-badge">Admin Panel</div></div>
    <div class="sidebar-menu">
        <a href="dashboard.jsp">📊 &nbsp;Dashboard</a>
        <a href="inventory.jsp" class="active">📦 &nbsp;Inventory</a>
        <a href="order.jsp">📋 &nbsp;Orders</a>
        <a href="../products">🛍️ &nbsp;View Store</a>
    </div>
    <div class="sidebar-footer">
        <div class="sidebar-user">Logged in as<strong><%= user.getUsername() %></strong></div>
        <a href="../auth?action=logout" class="btn-logout">Logout</a>
    </div>
</div>

<div class="main">
    <div class="topbar">
        <div>
            <div class="topbar-title">Inventory</div>
            <div class="topbar-sub"><%= list.size() %> products</div>
        </div>
    </div>

    <div class="content">
        <div class="add-form">
            <div class="form-title">Add New Sneaker</div>
            <form action="../products" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                <div class="form-grid">
                    <input type="text"   name="brand"    placeholder="Brand *" required>
                    <input type="text"   name="model"    placeholder="Model *" required>
                    <input type="number" name="size"     placeholder="Size (e.g. 42)" step="0.5" min="35" max="50">
                    <input type="text"   name="color"    placeholder="Color">
                    <input type="number" name="price"    placeholder="Price ($)" step="0.01" min="0">
                    <input type="number" name="stock"    placeholder="Stock qty" min="0">
                    <select name="category">
                        <option value="unisex">Unisex</option>
                        <option value="men">For Him (Men)</option>
                        <option value="women">For Her (Women)</option>
                        <option value="kids">For Kids</option>
                    </select>
                    <div class="file-upload-box" onclick="document.getElementById('addImageInput').click()">
                        <input type="file" id="addImageInput" name="imageFile"
                               accept=".jpg,.jpeg,.png,.webp"
                               onchange="previewImage(this,'addPreview')">
                        <label>
                            <div style="font-size:28px;margin-bottom:6px">📷</div>
                            <span>Click to upload image</span><br>
                            JPG, PNG, WEBP · Max 5MB
                        </label>
                        <div class="file-preview" id="addPreview">
                            <img id="addPreviewImg" src="#" alt="preview">
                            <div id="addFileName" style="font-size:12px;color:#555;margin-top:6px"></div>
                        </div>
                    </div>
                </div>
                <button type="submit" class="btn-add">+ Add Sneaker</button>
            </form>
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr><th>#</th><th>Brand</th><th>Model</th><th>Size</th><th>Color</th><th>Category</th><th>Price</th><th>Stock</th><th>Actions</th></tr>
                </thead>
                <tbody>
                <% for (Sneaker s : list) { %>
                    <tr>
                        <td style="color:#ccc"><%= s.getId() %></td>
                        <td style="font-weight:700;color:#111"><%= s.getBrand() %></td>
                        <td><%= s.getModel() %></td>
                        <td><%= s.getSize() %></td>
                        <td><%= s.getColor() %></td>
                        <td><span style="padding:3px 10px;border-radius:20px;font-size:10px;font-weight:700;background:<%= "men".equals(s.getCategory()) ? "#eff6ff" : "women".equals(s.getCategory()) ? "#fdf4ff" : "kids".equals(s.getCategory()) ? "#f0fdf4" : "#f8f8f8" %>;color:<%= "men".equals(s.getCategory()) ? "#3b82f6" : "women".equals(s.getCategory()) ? "#a855f7" : "kids".equals(s.getCategory()) ? "#22c55e" : "#888" %>"><%= s.getCategory() != null ? s.getCategory().toUpperCase() : "UNISEX" %></span></td>
                        <td style="font-weight:700">$<%= String.format("%.2f", s.getPrice()) %></td>
                        <td class="<%= s.getStock() == 0 ? "stock-out" : s.getStock() < 5 ? "stock-low" : "stock-ok" %>"><%= s.getStock() %></td>
                        <td>
                            <button class="btn-variants" onclick="openVariants(<%= s.getId() %>,'<%= s.getBrand() %> <%= s.getModel() %>')">🎨 Colours</button>
                            <button class="btn-edit" onclick="openEdit(<%= s.getId() %>,'<%= s.getBrand() %>','<%= s.getModel() %>','<%= s.getSize() %>','<%= s.getColor() %>','<%= s.getPrice() %>','<%= s.getStock() %>','<%= s.getCategory() != null ? s.getCategory() : "unisex" %>','<%= s.getImageUrl() != null ? s.getImageUrl() : "" %>')">Edit</button>
                            <form action="../products" method="post" style="display:inline" onsubmit="return confirm('Delete this sneaker?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= s.getId() %>">
                                <button type="submit" class="btn-delete">Delete</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- ── VARIANTS MODAL ─────────────────────────────── -->
<div class="modal-bg" id="variantsModal">
    <div class="vmodal">
        <div class="modal-header" style="display:flex;justify-content:space-between;align-items:center;">
            <div>
                <div class="modal-title">🎨 Colour Variants</div>
                <div id="vModalSub" style="font-size:12px;color:#aaa;margin-top:3px"></div>
            </div>
            <button type="button" class="btn-cancel" onclick="closeVariants()" style="padding:8px 16px;">✕ Close</button>
        </div>
        <div class="modal-body">
            <div id="variantList" class="variant-list">
                <div class="v-loading">Loading…</div>
            </div>

            <!-- Add new variant -->
            <div class="v-add-form">
                <div class="v-add-title">+ Add New Colour Variant</div>
                <div class="v-form-row">
                    <select class="v-color-select" id="vColorSelect">
                        <option value="">— Select Colour —</option>
                        <option value="Black">Black</option>
                        <option value="White">White</option>
                        <option value="Red">Red</option>
                        <option value="Blue">Blue</option>
                        <option value="Navy">Navy</option>
                        <option value="Gray">Gray</option>
                        <option value="Green">Green</option>
                        <option value="Orange">Orange</option>
                        <option value="Pink">Pink</option>
                        <option value="Yellow">Yellow</option>
                        <option value="Brown">Brown</option>
                        <option value="Purple">Purple</option>
                        <option value="Beige">Beige</option>
                        <option value="Teal">Teal</option>
                        <option value="Maroon">Maroon</option>
                    </select>
                    <div class="v-file-box" onclick="document.getElementById('vFileInput').click()">
                        <input type="file" id="vFileInput" accept=".jpg,.jpeg,.png,.webp"
                               onchange="vPreviewFile(this)">
                        <label>
                            <div style="font-size:22px;margin-bottom:4px">📷</div>
                            <span>Upload image</span><br>
                            <small style="color:#ccc">JPG PNG WEBP · Max 5MB</small>
                        </label>
                        <div class="v-preview" id="vFilePreview">
                            <img id="vPreviewImg" src="#" alt="preview">
                        </div>
                    </div>
                    <button type="button" class="btn-vadd" onclick="submitVariant()">Add</button>
                </div>
                <div id="vAddMsg" style="font-size:12px;margin-top:10px;"></div>
            </div>
        </div>
    </div>
</div>

<div class="modal-bg" id="editModal">
    <div class="modal">
        <div class="modal-header"><div class="modal-title">Edit Sneaker</div></div>
        <div class="modal-body">
            <form action="../products" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action"        value="edit">
                <input type="hidden" name="id"            id="edit-id">
                <input type="hidden" name="existingImage" id="edit-existing-image">
                <div class="modal-grid">
                    <input type="text"   name="brand"  id="edit-brand"  placeholder="Brand">
                    <input type="text"   name="model"  id="edit-model"  placeholder="Model">
                    <input type="number" name="size"   id="edit-size"   placeholder="Size" step="0.5">
                    <input type="text"   name="color"  id="edit-color"  placeholder="Color">
                    <input type="number" name="price"  id="edit-price"  placeholder="Price" step="0.01">
                    <input type="number" name="stock"  id="edit-stock"  placeholder="Stock">
                    <select name="category" id="edit-category">
                        <option value="unisex">Unisex</option>
                        <option value="men">For Him (Men)</option>
                        <option value="women">For Her (Women)</option>
                        <option value="kids">For Kids</option>
                    </select>
                    <div class="file-upload-box" onclick="document.getElementById('editImageInput').click()" style="grid-column:1/-1">
                        <input type="file" id="editImageInput" name="imageFile"
                               accept=".jpg,.jpeg,.png,.webp"
                               onchange="previewImage(this,'editPreview')">
                        <label>
                            <div id="editCurrentImg" style="margin-bottom:8px"></div>
                            <span>Click to replace image</span><br>
                            <small style="color:#bbb">Leave blank to keep current image</small>
                        </label>
                        <div class="file-preview" id="editPreview">
                            <img id="editPreviewImg" src="#" alt="preview">
                            <div id="editFileName" style="font-size:12px;color:#555;margin-top:6px"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn-save">Save Changes</button>
                    <button type="button" class="btn-cancel" onclick="closeEdit()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
var ctxPath = '<%= request.getContextPath() %>';
var currentSneakerId = null;

// colour → CSS hex
var colorHex = {
    black:'#111111',white:'#FFFFFF',red:'#EF4444',blue:'#3B82F6',
    navy:'#1E3A5F',gray:'#9CA3AF',green:'#22C55E',orange:'#FF6B2B',
    pink:'#EC4899',yellow:'#EAB308',brown:'#92400E',purple:'#8B5CF6',
    beige:'#D4C5A9',teal:'#14B8A6',maroon:'#7F1D1D'
};

// ── Open/Close ───────────────────────────────────────
function openVariants(sneakerId, sneakerName) {
    currentSneakerId = sneakerId;
    document.getElementById('vModalSub').textContent = sneakerName;
    document.getElementById('variantsModal').classList.add('show');
    document.getElementById('vAddMsg').textContent = '';
    document.getElementById('vColorSelect').value = '';
    document.getElementById('vFileInput').value = '';
    document.getElementById('vFilePreview').style.display = 'none';
    loadVariants(sneakerId);
}
function closeVariants() {
    document.getElementById('variantsModal').classList.remove('show');
    currentSneakerId = null;
}

// ── Load variant list via AJAX ───────────────────────
function loadVariants(sneakerId) {
    var list = document.getElementById('variantList');
    list.innerHTML = '<div class="v-loading">Loading…</div>';

    fetch(ctxPath + '/variants?sneakerId=' + sneakerId)
        .then(function(r){ return r.json(); })
        .then(function(data) {
            if (!data || data.length === 0) {
                list.innerHTML = '<div class="v-empty">No colour variants yet. Add one below.</div>';
                return;
            }
            list.innerHTML = '';
            data.forEach(function(v) {
                var hex   = colorHex[v.color.toLowerCase()] || '#888888';
                var white = v.color.toLowerCase() === 'white';
                var imgHtml = v.imageUrl
                    ? '<img class="v-thumb" src="' + ctxPath + '/images/sneakers/' + v.imageUrl + '" alt="' + v.color + '">'
                    : '<div class="v-thumb-ph">👟</div>';
                var row = document.createElement('div');
                row.className = 'variant-row';
                row.id = 'vrow-' + v.id;
                row.innerHTML =
                    '<div class="v-swatch" style="background:' + hex + ';' + (white ? 'border-color:#ddd;' : '') + '"></div>' +
                    imgHtml +
                    '<span class="v-color-name">' + v.color + '</span>' +
                    '<button class="btn-vdel" onclick="deleteVariant(' + v.id + ')">✕ Remove</button>';
                list.appendChild(row);
            });
        })
        .catch(function(){ list.innerHTML = '<div class="v-empty" style="color:#ef4444">Failed to load variants.</div>'; });
}

// ── Delete variant ───────────────────────────────────
function deleteVariant(id) {
    if (!confirm('Remove this colour variant?')) return;
    var formData = new FormData();
    formData.append('action', 'delete');
    formData.append('id', id);

    fetch(ctxPath + '/variants', { method: 'POST', body: formData })
        .then(function(r){ return r.json(); })
        .then(function(res){
            if (res.success) {
                var row = document.getElementById('vrow-' + id);
                if (row) row.remove();
                var list = document.getElementById('variantList');
                if (list.children.length === 0)
                    list.innerHTML = '<div class="v-empty">No colour variants yet. Add one below.</div>';
            }
        });
}

// ── Submit new variant ───────────────────────────────
function submitVariant() {
    var color = document.getElementById('vColorSelect').value;
    var file  = document.getElementById('vFileInput').files[0];
    var msg   = document.getElementById('vAddMsg');

    if (!color)  { msg.style.color='#ef4444'; msg.textContent='Please select a colour.'; return; }
    if (!file)   { msg.style.color='#ef4444'; msg.textContent='Please upload an image.'; return; }

    msg.style.color = '#aaa';
    msg.textContent = 'Uploading…';

    var formData = new FormData();
    formData.append('action',    'add');
    formData.append('sneakerId', currentSneakerId);
    formData.append('color',     color);
    formData.append('imageFile', file);

    fetch(ctxPath + '/variants', { method: 'POST', body: formData })
        .then(function(r){ return r.json(); })
        .then(function(res) {
            if (res.success) {
                msg.style.color = '#22c55e';
                msg.textContent = '✓ Colour variant added!';
                document.getElementById('vColorSelect').value = '';
                document.getElementById('vFileInput').value = '';
                document.getElementById('vFilePreview').style.display = 'none';
                loadVariants(currentSneakerId);
            } else {
                msg.style.color = '#ef4444';
                msg.textContent = res.error || 'Upload failed.';
            }
        })
        .catch(function(){ msg.style.color='#ef4444'; msg.textContent='Network error.'; });
}

// ── Preview selected file ────────────────────────────
function vPreviewFile(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('vPreviewImg').src = e.target.result;
            document.getElementById('vFilePreview').style.display = 'block';
        };
        reader.readAsDataURL(input.files[0]);
    }
}

function openEdit(id, brand, model, size, color, price, stock, category, imageFile) {
    document.getElementById("edit-id").value             = id;
    document.getElementById("edit-brand").value          = brand;
    document.getElementById("edit-model").value          = model;
    document.getElementById("edit-size").value           = size;
    document.getElementById("edit-color").value          = color;
    document.getElementById("edit-price").value          = price;
    document.getElementById("edit-stock").value          = stock;
    document.getElementById("edit-category").value       = category;
    document.getElementById("edit-existing-image").value = imageFile;

    // Show current image if exists
    var currentImgDiv = document.getElementById("editCurrentImg");
    if (imageFile && imageFile !== '') {
        currentImgDiv.innerHTML = '<img src="../images/sneakers/' + imageFile + '" style="width:70px;height:70px;object-fit:cover;border-radius:4px;border:2px solid #f0f0f0">';
    } else {
        currentImgDiv.innerHTML = '<span style="font-size:40px">👟</span>';
    }
    // Reset preview
    document.getElementById("editPreview").style.display = "none";
    document.getElementById("editImageInput").value = "";
    document.getElementById("editModal").classList.add("show");
}
function closeEdit() { document.getElementById("editModal").classList.remove("show"); }

function previewImage(input, previewId) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        var preview = document.getElementById(previewId);
        var previewImg = document.getElementById(previewId + 'Img');
        var fileName = document.getElementById(previewId.replace('Preview','') + 'FileName');
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            preview.style.display = "block";
            if (fileName) fileName.textContent = input.files[0].name + ' (' + (input.files[0].size / 1024).toFixed(0) + ' KB)';
        };
        reader.readAsDataURL(input.files[0]);
    }
}
</script>
</body>
</html>
