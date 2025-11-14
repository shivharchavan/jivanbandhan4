<%@ Page Title="Marathi Matrimony - View Profile" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="ViewUserProfile.aspx.cs" Inherits="JivanBandhan4.ViewUserProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .profile-view-container {
            background: linear-gradient(135deg, #f8f9ff 0%, #eef2ff 50%, #f0f4ff 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .profile-view-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 300px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            clip-path: polygon(0 0, 100% 0, 100% 70%, 0 100%);
            z-index: 0;
        }
        
        .profile-header-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            color: #2c3e50;
            border-radius: 25px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.1);
            position: relative;
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 1;
        }
        
        .profile-main-layout {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 30px;
            margin-top: 20px;
            position: relative;
            z-index: 1;
        }
        
        .profile-sidebar {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            border-radius: 25px;
            padding: 25px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            height: fit-content;
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
        }
        
        .profile-content {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            border-radius: 25px;
            padding: 35px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
        }
        
        /* Profile Photo Flip Effect */
        .profile-photo-flip-container {
            perspective: 1000px;
            width: 280px;
            height: 280px;
            margin: 0 auto 25px;
            cursor: pointer;
        }

        .profile-photo-flip-inner {
            position: relative;
            width: 100%;
            height: 100%;
            text-align: center;
            transition: transform 0.8s;
            transform-style: preserve-3d;
        }

        .profile-photo-flip-container:hover .profile-photo-flip-inner {
            transform: rotateY(180deg);
        }

        .profile-photo-front, .profile-photo-back {
            position: absolute;
            width: 100%;
            height: 100%;
            backface-visibility: hidden;
            border-radius: 20px;
            border: 8px solid rgba(255,255,255,0.9);
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
        }

        .profile-photo-back {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: rotateY(180deg);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 20px;
            text-align: center;
        }

        .profile-photo-back-content h4 {
            color: white;
            margin-bottom: 10px;
            font-size: 1.2rem;
        }

        .profile-photo-back-content p {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
            margin-bottom: 5px;
        }

        .user-photo-extra-large {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 12px;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 4px;
            cursor: pointer;
        }
        
        .profile-name-large {
            font-size: 2rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
            text-align: center;
        }
        
        .profile-basic-info {
            background: rgba(248,249,250,0.7);
            padding: 20px;
            border-radius: 20px;
            margin: 20px 0;
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-value {
            color: #6c757d;
            text-align: right;
        }

        /* Platinum Member Badge */
        .platinum-badge {
            background: linear-gradient(135deg, #e5e4e2 0%, #d4af37 50%, #e5e4e2 100%);
            color: #2c3e50;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.8rem;
            margin-bottom: 15px;
            text-align: center;
            border: 2px solid #d4af37;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
            animation: platinum-glow 2s infinite alternate;
        }

        @keyframes platinum-glow {
            from { box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3); }
            to { box-shadow: 0 4px 25px rgba(212, 175, 55, 0.6); }
        }

        .contact-number-platinum {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 12px;
            border-radius: 15px;
            margin: 15px 0;
            text-align: center;
            font-weight: bold;
            font-size: 1.1rem;
            border: 2px solid #fff;
            box-shadow: 0 5px 20px rgba(40, 167, 69, 0.4);
            animation: contact-pulse 3s infinite;
        }

        @keyframes contact-pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.02); }
            100% { transform: scale(1); }
        }

        .contact-info-restricted {
            background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
            color: white;
            padding: 12px;
            border-radius: 15px;
            margin: 15px 0;
            text-align: center;
            font-weight: bold;
            font-size: 1rem;
            border: 2px solid #fff;
            box-shadow: 0 5px 20px rgba(255, 193, 7, 0.4);
        }
        
        .platinum-info-message {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            padding: 10px 15px;
            border-radius: 15px;
            margin: 10px 0;
            text-align: center;
            font-size: 0.9rem;
            border: 2px solid #fff;
        }
        
        .section-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%) 1;
            padding-bottom: 15px;
            margin: 30px 0 20px 0;
            font-size: 1.5rem;
            font-weight: bold;
            position: relative;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .detail-card {
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            border-radius: 20px;
            padding: 25px;
            border: 1px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            backdrop-filter: blur(5px);
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin: 30px 0;
            flex-wrap: wrap;
        }
        
        .btn-profile-action {
            padding: 15px 25px;
            border: none;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            min-width: 160px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-interest {
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(214, 51, 132, 0.4);
        }
        
        .btn-message {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-shortlist {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }

        /* Block & Report Button Styles for View Profile */
        .btn-block {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }

        .btn-report {
            background: linear-gradient(135deg, #fd7e14 0%, #e55a00 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(253, 126, 20, 0.4);
        }

        .block-report-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid rgba(0,0,0,0.1);
        }

        .btn-block-report-large {
            padding: 12px 20px;
            border: none;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-bottom: 10px;
            position: relative;
            overflow: hidden;
        }

        .btn-block-report-large:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .online-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 15px;
        }
        
        .online {
            background: rgba(81, 207, 102, 0.2);
            color: #2d8a3e;
            border: 1px solid rgba(81, 207, 102, 0.3);
        }
        
        .offline {
            background: rgba(108, 117, 125, 0.2);
            color: #495057;
            border: 1px solid rgba(108, 117, 125, 0.3);
        }
        
        .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
        }
        
        .online .status-dot {
            background: #51cf66;
            animation: pulse-online 2s infinite;
        }
        
        .offline .status-dot {
            background: #6c757d;
        }

        /* Photo Gallery Styles - IMPROVED */
        .photo-gallery-section {
            margin: 30px 0;
        }

        .gallery-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #667eea 0%, #764ba2 100%) 1;
            padding-bottom: 12px;
            margin: 25px 0 15px 0;
            font-size: 1.3rem;
            font-weight: bold;
        }

        .photo-gallery {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .gallery-item {
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            border: 3px solid transparent;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3px;
            aspect-ratio: 1;
        }

        .gallery-item:hover {
            transform: translateY(-8px) scale(1.05);
            box-shadow: 0 15px 40px rgba(0,0,0,0.25);
            border-color: rgba(102, 126, 234, 0.5);
        }

        .gallery-photo {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 12px;
            transition: all 0.4s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%);
        }

        .gallery-item:hover .gallery-photo {
            transform: scale(1.1);
        }

        .photo-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.7));
            padding: 10px;
            color: white;
            font-size: 0.8rem;
            opacity: 0;
            transition: all 0.3s ease;
            transform: translateY(10px);
        }

        .gallery-item:hover .photo-overlay {
            opacity: 1;
            transform: translateY(0);
        }

        /* IMPROVED Fullscreen Modal Styles */
        .photo-modal {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.95);
            backdrop-filter: blur(10px);
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-content-wrapper {
            position: relative;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .modal-image {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
            border-radius: 10px;
            box-shadow: 0 25px 80px rgba(0,0,0,0.5);
            animation: zoomIn 0.3s ease;
        }

        @keyframes zoomIn {
            from { transform: scale(0.7); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        .close-modal {
            position: absolute;
            top: 20px;
            right: 30px;
            color: white;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
            z-index: 10001;
            background: rgba(0,0,0,0.5);
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            border: 2px solid rgba(255,255,255,0.3);
        }

        .close-modal:hover {
            background: rgba(220, 53, 69, 0.8);
            transform: scale(1.1);
            border-color: rgba(255,255,255,0.5);
        }

        .modal-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            font-size: 24px;
            padding: 15px;
            cursor: pointer;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            border: 2px solid rgba(255,255,255,0.3);
            z-index: 10001;
        }

        .modal-nav:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-50%) scale(1.1);
            border-color: rgba(255,255,255,0.5);
        }

        .prev-nav {
            left: 30px;
        }

        .next-nav {
            right: 30px;
        }

        .modal-counter {
            position: absolute;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            color: white;
            background: rgba(0,0,0,0.7);
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 1rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 10001;
        }

        .modal-loader {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-size: 1.2rem;
        }

        .no-photos-message {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
            background: rgba(248,249,250,0.7);
            border-radius: 15px;
            border: 2px dashed #dee2e6;
        }

        .no-photos-message i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: #adb5bd;
        }

        /* Loading animation for images */
        .image-loading {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }

        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }

        @keyframes pulse-online {
            0% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(81, 207, 102, 0); }
            100% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0); }
        }

        @media (max-width: 992px) {
            .profile-main-layout {
                grid-template-columns: 1fr;
            }
            
            .profile-photo-flip-container {
                width: 220px;
                height: 220px;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-profile-action {
                width: 100%;
                max-width: 300px;
            }
            
            .photo-gallery {
                grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            }

            .modal-nav {
                width: 50px;
                height: 50px;
                font-size: 20px;
            }

            .prev-nav {
                left: 15px;
            }

            .next-nav {
                right: 15px;
            }

            .close-modal {
                top: 15px;
                right: 20px;
                width: 45px;
                height: 45px;
                font-size: 35px;
            }
        }
        
        @media (max-width: 768px) {
            .profile-header-banner {
                padding: 20px;
            }
            
            .profile-content {
                padding: 25px;
            }
            
            .profile-sidebar {
                padding: 20px;
            }
            
            .profile-photo-flip-container {
                width: 200px;
                height: 200px;
            }
            
            .profile-name-large {
                font-size: 1.7rem;
            }
            
            .modal-image {
                max-width: 95%;
                max-height: 85%;
            }

            .modal-nav {
                width: 45px;
                height: 45px;
                font-size: 18px;
                padding: 12px;
            }

            .modal-counter {
                bottom: 20px;
                font-size: 0.9rem;
                padding: 8px 16px;
            }
        }

        @media (max-width: 480px) {
            .photo-gallery {
                grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
                gap: 10px;
            }

            .modal-nav {
                width: 40px;
                height: 40px;
                font-size: 16px;
                padding: 10px;
            }

            .prev-nav {
                left: 10px;
            }

            .next-nav {
                right: 10px;
            }

            .close-modal {
                width: 40px;
                height: 40px;
                font-size: 30px;
                top: 10px;
                right: 15px;
            }
        }
    </style>

    <div class="profile-view-container">
        <div class="container">
            <!-- Profile Header -->
            <div class="profile-header-banner">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font">Profile Details</h1>
                        <p class="marathi-font mb-0">Complete profile information</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <asp:Button ID="btnBack" runat="server" Text="⬅ Back to Dashboard" 
                            CssClass="btn btn-secondary marathi-font" OnClick="btnBack_Click" />
                    </div>
                </div>
            </div>

            <!-- Main Profile Layout -->
            <div class="profile-main-layout">
                <!-- Left Sidebar -->
                <div class="profile-sidebar">
                    <!-- Platinum Membership Badge -->
                    <asp:Panel ID="pnlPlatinumBadge" runat="server" CssClass="platinum-badge marathi-font" Visible="false">
                        ⭐ PLATINUM MEMBER - Contact Number Visible
                    </asp:Panel>

                    <!-- Contact Number for Platinum Members -->
                    <asp:Panel ID="pnlContactNumber" runat="server" CssClass="contact-number-platinum marathi-font" Visible="false">
                        <i class="fas fa-phone"></i> Contact: 
                        <asp:Label ID="lblContactNumber" runat="server" Text=""></asp:Label>
                    </asp:Panel>

                    <!-- Contact Restricted Message -->
                    <asp:Panel ID="pnlContactRestricted" runat="server" CssClass="contact-info-restricted marathi-font" Visible="false">
                        <i class="fas fa-info-circle"></i> Contact number available only for Platinum members
                    </asp:Panel>

                    <!-- Platinum Info Message -->
                    <asp:Panel ID="pnlPlatinumInfo" runat="server" CssClass="platinum-info-message marathi-font" Visible="false">
                        <i class="fas fa-crown"></i> Upgrade to Platinum to view contact numbers
                    </asp:Panel>

                    <!-- Flip Profile Photo Container -->
                    <div class="profile-photo-flip-container">
                        <div class="profile-photo-flip-inner">
                            <div class="profile-photo-front">
                                <asp:Image ID="imgProfileLarge" runat="server" CssClass="user-photo-extra-large" 
                                    ImageUrl="~/Images/default-profile.jpg" 
                                    onerror="this.src='Images/default-profile.jpg'"/>
                            </div>
                            <div class="profile-photo-back">
                                <div class="profile-photo-back-content">
                                    <h4 class="marathi-font">प्रोफाइल तपशील</h4>
                                    <p class="marathi-font"><strong>नाव:</strong> <asp:Label ID="lblFlipName" runat="server" Text=""></asp:Label></p>
                                    <p class="marathi-font"><strong>वय:</strong> <asp:Label ID="lblFlipAge" runat="server" Text=""></asp:Label></p>
                                    <p class="marathi-font"><strong>ठिकाण:</strong> <asp:Label ID="lblFlipLocation" runat="server" Text=""></asp:Label></p>
                                    <p class="marathi-font"><strong>व्यवसाय:</strong> <asp:Label ID="lblFlipOccupation" runat="server" Text=""></asp:Label></p>
                                    <p class="marathi-font"><small>फोटोवर क्लिक करा मोठे पहाण्यासाठी</small></p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Online Status -->
                    <div class="online-status marathi-font" id="onlineStatus" runat="server">
                        <div class="status-dot"></div>
                        <span id="statusText" runat="server">Online</span>
                    </div>
                    
                    <div class="profile-name-large marathi-font">
                        <asp:Label ID="lblFullName" runat="server" Text=""></asp:Label>
                    </div>
                    
                    <!-- Basic Information -->
                    <div class="profile-basic-info">
                        <div class="info-item marathi-font">
                            <span class="info-label">Profile ID:</span>
                            <span class="info-value">
                                <asp:Label ID="lblProfileID" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Age:</span>
                            <span class="info-value">
                                <asp:Label ID="lblAge" runat="server" Text=""></asp:Label> Years
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Height:</span>
                            <span class="info-value">
                                <asp:Label ID="lblHeight" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <!-- Phone Number will be displayed here only for Platinum members -->
                        <asp:Panel ID="pnlPhoneBasicInfo" runat="server" Visible="false">
                            <div class="info-item marathi-font">
                                <span class="info-label">Phone Number:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPhone" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </asp:Panel>
                        <div class="info-item marathi-font">
                            <span class="info-label">Religion:</span>
                            <span class="info-value">
                                <asp:Label ID="lblReligion" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Caste:</span>
                            <span class="info-value">
                                <asp:Label ID="lblCaste" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Location:</span>
                            <span class="info-value">
                                <asp:Label ID="lblLocation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Occupation:</span>
                            <span class="info-value">
                                <asp:Label ID="lblOccupation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Education:</span>
                            <span class="info-value">
                                <asp:Label ID="lblEducation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Marital Status:</span>
                            <span class="info-value">
                                <asp:Label ID="lblMaritalStatus" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <asp:Button ID="btnSendInterest" runat="server" Text="💝 Send Interest" 
                            CssClass="btn-profile-action btn-interest marathi-font" OnClientClick="sendInterest(); return false;" />
                        <asp:Button ID="btnSendMessage" runat="server" Text="💌 Send Message" 
                            CssClass="btn-profile-action btn-message marathi-font" OnClientClick="sendMessage(); return false;" />
                        <asp:Button ID="btnShortlist" runat="server" Text="⭐ Shortlist" 
                            CssClass="btn-profile-action btn-shortlist marathi-font" OnClientClick="shortlistProfile(); return false;" />
                    </div>

                    <!-- Block & Report Section -->
                    <div class="block-report-section">
                        <h5 class="marathi-font text-center mb-3">Safety & Privacy</h5>
                        <button class="btn-block-report-large btn-block marathi-font" 
                            onclick='blockUser()'>
                            🚫 Block User
                        </button>
                        <button class="btn-block-report-large btn-report marathi-font" 
                            onclick='reportUser()'>
                            ⚠ Report Profile
                        </button>
                    </div>
                </div>
                
                <!-- Right Content -->
                <div class="profile-content">
                    <!-- Photo Gallery Section -->
                    <div class="photo-gallery-section">
                        <h3 class="gallery-title marathi-font">
                            <i class="fas fa-images"></i> Photo Gallery
                        </h3>
                        
                        <div class="photo-gallery" id="photoGallery" runat="server">
                            <!-- Photos will be dynamically added here -->
                        </div>
                        
                        <asp:Panel ID="pnlNoPhotos" runat="server" CssClass="no-photos-message" Visible="false">
                            <i class="fas fa-camera"></i>
                            <h5 class="marathi-font">No Photos Available</h5>
                            <p class="marathi-font">This user hasn't uploaded any photos yet.</p>
                        </asp:Panel>
                    </div>

                    <!-- Personal Information -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-user"></i> Personal Information
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #d63384; margin-bottom: 15px;">
                                <i class="fas fa-info-circle"></i> Basic Details
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Full Name:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalFullName" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Gender:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblGender" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Date of Birth:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblDOB" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Marital Status:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalMaritalStatus" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #667eea; margin-bottom: 15px;">
                                <i class="fas fa-heart"></i> Religious Details
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Religion:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalReligion" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Caste:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalCaste" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Sub Caste:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblSubCaste" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Manglik:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblManglik" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Education & Career -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-graduation-cap"></i> Education & Career
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #28a745; margin-bottom: 15px;">
                                <i class="fas fa-university"></i> Education
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Highest Education:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblHighestEducation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Education Field:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblEducationField" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">College/University:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblCollege" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #ffc107; margin-bottom: 15px;">
                                <i class="fas fa-briefcase"></i> Career
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblCareerOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Occupation Field:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblOccupationField" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Annual Income:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblAnnualIncome" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Family Information -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-home"></i> Family Information
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #dc3545; margin-bottom: 15px;">
                                <i class="fas fa-users"></i> Family Background
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Family Type:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblFamilyType" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Father's Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblFatherOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Mother's Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblMotherOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- IMPROVED Fullscreen Photo Modal -->
    <div id="photoModal" class="photo-modal">
        <div class="modal-content-wrapper">
            <span class="close-modal" onclick="closePhotoModal()">&times;</span>
            <button class="modal-nav prev-nav" onclick="changePhoto(-1)">&#10094;</button>
            <button class="modal-nav next-nav" onclick="changePhoto(1)">&#10095;</button>
            
            <div class="modal-loader" id="modalLoader" style="display: none;">
                <i class="fas fa-spinner fa-spin"></i> Loading...
            </div>
            
            <img class="modal-image" id="modalImage" 
                 onload="hideLoader()" 
                 onerror="this.src='Images/default-profile.jpg'; hideLoader()" />
                 
            <div class="modal-counter" id="modalCounter">1 / 1</div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnViewedUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnUserPhotos" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // Global variables for photo gallery
        let currentPhotoIndex = 0;
        let userPhotos = [];

        // Initialize photo gallery from hidden field
        function initializePhotoGallery() {
            const photosData = document.getElementById('<%= hdnUserPhotos.ClientID %>').value;

            if (photosData && photosData !== '[]' && photosData !== '') {
                try {
                    userPhotos = JSON.parse(photosData);
                } catch (e) {
                    console.error("Error parsing photos data:", e);
                    userPhotos = [];
                }
            } else {
                userPhotos = [];
            }

            // Always include profile photo as first image
            const profilePhotoUrl = document.getElementById('<%= imgProfileLarge.ClientID %>').src;

            if (profilePhotoUrl && !profilePhotoUrl.includes('default-profile.jpg')) {
                // Check if profile photo already exists in userPhotos
                const profilePhotoExists = userPhotos.some(photo =>
                    photo.url === profilePhotoUrl || photo.IsProfilePhoto
                );

                if (!profilePhotoExists) {
                    userPhotos.unshift({
                        url: profilePhotoUrl,
                        title: 'Profile Photo',
                        IsProfilePhoto: true
                    });
                }
            }

            // Update hidden field with corrected data
            document.getElementById('<%= hdnUserPhotos.ClientID %>').value = JSON.stringify(userPhotos);
        }

        // Show loader
        function showLoader() {
            document.getElementById('modalLoader').style.display = 'block';
        }

        // Hide loader
        function hideLoader() {
            document.getElementById('modalLoader').style.display = 'none';
        }

        // Open modal with specific photo - FIXED VERSION
        function openPhotoModal(index) {
            if (userPhotos.length === 0) {
                alert('No photos available to display.');
                return;
            }

            // Validate index
            if (index < 0 || index >= userPhotos.length) {
                index = 0;
            }

            currentPhotoIndex = index;
            const modal = document.getElementById('photoModal');
            const modalImg = document.getElementById('modalImage');
            const modalCounter = document.getElementById('modalCounter');

            // Show loader
            showLoader();

            // Set image source with cache busting
            const photoUrl = userPhotos[currentPhotoIndex].url + '?t=' + new Date().getTime();
            modalImg.src = photoUrl;
            modalCounter.textContent = `${currentPhotoIndex + 1} / ${userPhotos.length}`;

            // Show modal
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden';

            // Add loading class to image
            modalImg.classList.add('image-loading');
        }

        // Close modal
        function closePhotoModal() {
            const modal = document.getElementById('photoModal');
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';

            // Remove loading class
            const modalImg = document.getElementById('modalImage');
            modalImg.classList.remove('image-loading');
        }

        // Change photo in modal
        function changePhoto(direction) {
            if (userPhotos.length <= 1) return;

            currentPhotoIndex += direction;

            // Loop around
            if (currentPhotoIndex >= userPhotos.length) {
                currentPhotoIndex = 0;
            } else if (currentPhotoIndex < 0) {
                currentPhotoIndex = userPhotos.length - 1;
            }

            const modalImg = document.getElementById('modalImage');
            const modalCounter = document.getElementById('modalCounter');

            // Show loader
            showLoader();

            // Add loading class
            modalImg.classList.add('image-loading');

            // Change image source with cache busting
            const photoUrl = userPhotos[currentPhotoIndex].url + '?t=' + new Date().getTime();
            modalImg.src = photoUrl;
            modalCounter.textContent = `${currentPhotoIndex + 1} / ${userPhotos.length}`;
        }

        // Keyboard navigation
        document.addEventListener('keydown', function (event) {
            const modal = document.getElementById('photoModal');
            if (modal.style.display === 'block') {
                if (event.key === 'Escape') {
                    closePhotoModal();
                } else if (event.key === 'ArrowLeft') {
                    changePhoto(-1);
                } else if (event.key === 'ArrowRight') {
                    changePhoto(1);
                } else if (event.key === ' ') {
                    // Space bar to toggle next photo
                    changePhoto(1);
                    event.preventDefault();
                }
            }
        });

        // Close modal when clicking outside image
        document.getElementById('photoModal').addEventListener('click', function (event) {
            if (event.target === this) {
                closePhotoModal();
            }
        });

        // Touch events for mobile swipe
        let touchStartX = 0;
        let touchEndX = 0;

        document.addEventListener('touchstart', function (e) {
            touchStartX = e.changedTouches[0].screenX;
        }, false);

        document.addEventListener('touchend', function (e) {
            touchEndX = e.changedTouches[0].screenX;
            handleSwipe();
        }, false);

        function handleSwipe() {
            const modal = document.getElementById('photoModal');
            if (modal.style.display !== 'block') return;

            const swipeThreshold = 50;

            if (touchEndX < touchStartX - swipeThreshold) {
                // Swipe left - next photo
                changePhoto(1);
            }

            if (touchEndX > touchStartX + swipeThreshold) {
                // Swipe right - previous photo
                changePhoto(-1);
            }
        }

        // FIXED: Add click events to gallery items
        function attachGalleryClickEvents() {
            const galleryItems = document.querySelectorAll('.gallery-item');

            galleryItems.forEach((item, index) => {
                // Remove any existing click events and add new one
                const newItem = item.cloneNode(true);
                item.parentNode.replaceChild(newItem, item);

                // Add click event to the new item
                newItem.addEventListener('click', function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    openPhotoModal(index);
                });
            });

            // Also attach to profile photo flip container
            const profilePhotoContainer = document.querySelector('.profile-photo-flip-container');
            if (profilePhotoContainer) {
                profilePhotoContainer.onclick = function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    openPhotoModal(0); // Profile photo is always first
                };
            }
        }

        // Send Interest Function
        function sendInterest() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to send interest');
                return;
            }

            if (confirm('Are you interested in this profile?')) {
                const button = document.getElementById('<%= btnSendInterest.ClientID %>');
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/SendInterest",
                    data: JSON.stringify({
                        sentByUserID: parseInt(currentUserID),
                        targetUserID: parseInt(viewedUserID)
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Interest Sent';
                            button.style.background = '#28a745';
                            button.disabled = true;
                            showNotification('Interest sent successfully!', 'success');
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Sent';
                            button.style.background = '#ffc107';
                            button.disabled = true;
                            showNotification('You have already sent interest to this profile!', 'info');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending interest!', 'error');
                    }
                });
            }
        }

        // Send Message Function
        function sendMessage() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to send message');
                return;
            }

            const message = prompt('Enter your message:');
            if (message) {
                const button = document.getElementById('<%= btnSendMessage.ClientID %>');
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/SendMessage",
                    data: JSON.stringify({
                        fromUserID: parseInt(currentUserID),
                        toUserID: parseInt(viewedUserID),
                        messageText: message
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Message Sent';
                            button.style.background = '#28a745';
                            button.disabled = true;
                            showNotification('Message sent successfully!', 'success');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending message!', 'error');
                    }
                });
            }
        }

        // Shortlist Profile Function
        function shortlistProfile() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to shortlist profile');
                return;
            }

            const button = document.getElementById('<%= btnShortlist.ClientID %>');
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            $.ajax({
                type: "POST",
                url: "ViewUserProfile.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: parseInt(viewedUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = '#28a745';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = '#ffc107';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Block User Function for View Profile
        function blockUser() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to block user');
                return;
            }

            if (confirm('Are you sure you want to block this user? You will no longer see their profile and they will not be able to contact you.')) {
                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/BlockUser",
                    data: JSON.stringify({
                        blockedByUserID: parseInt(currentUserID),
                        blockedUserID: parseInt(viewedUserID)
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            showNotification('User blocked successfully! Redirecting...', 'success');
                            setTimeout(() => {
                                window.location.href = 'Dashboard.aspx';
                            }, 2000);
                        } else if (response.d === "exists") {
                            showNotification('You have already blocked this user!', 'info');
                        } else {
                            showNotification('Error blocking user!', 'error');
                        }
                    },
                    error: function () {
                        showNotification('Error blocking user!', 'error');
                    }
                });
            }
        }

        // Report User Function for View Profile
        function reportUser() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to report profile');
                return;
            }

            const reportReason = prompt('Please specify the reason for reporting this profile:');
            if (reportReason) {
                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/ReportUser",
                    data: JSON.stringify({
                        reportedByUserID: parseInt(currentUserID),
                        reportedUserID: parseInt(viewedUserID),
                        reportReason: reportReason
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            showNotification('Profile reported successfully! Our team will review this profile.', 'success');
                        } else {
                            showNotification('Error reporting profile!', 'error');
                        }
                    },
                    error: function () {
                        showNotification('Error reporting profile!', 'error');
                    }
                });
            }
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px 20px';
            notification.style.borderRadius = '10px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';
            notification.style.transition = 'all 0.3s ease';

            if (type === 'success') {
                notification.style.background = 'linear-gradient(135deg, #28a745, #20c997)';
            } else if (type === 'error') {
                notification.style.background = 'linear-gradient(135deg, #dc3545, #c82333)';
            } else if (type === 'info') {
                notification.style.background = 'linear-gradient(135deg, #17a2b8, #138496)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            // Animate in
            setTimeout(() => {
                notification.style.transform = 'translateX(0)';
            }, 10);

            setTimeout(() => {
                notification.style.opacity = '0';
                notification.style.transform = 'translateX(100px)';
                setTimeout(() => {
                    if (document.body.contains(notification)) {
                        document.body.removeChild(notification);
                    }
                }, 300);
            }, 3000);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize photo gallery
            initializePhotoGallery();
            
            // Attach click events after a short delay to ensure DOM is ready
            setTimeout(() => {
                attachGalleryClickEvents();
            }, 100);

            // Set random online status (for demo)
            const onlineStatus = document.getElementById('<%= onlineStatus.ClientID %>');
            const statusText = document.getElementById('<%= statusText.ClientID %>');
            const isOnline = Math.random() > 0.5;

            if (onlineStatus && statusText) {
                if (isOnline) {
                    onlineStatus.className = 'online-status marathi-font online';
                    statusText.textContent = 'Online Now';
                } else {
                    onlineStatus.className = 'online-status marathi-font offline';
                    statusText.textContent = 'Offline';
                }
            }
        });

        // Additional initialization when window is fully loaded
        window.addEventListener('load', function () {
            attachGalleryClickEvents();
        });
    </script>
</asp:Content>





















<%--<%@ Page Title="Marathi Matrimony - View Profile" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="ViewUserProfile.aspx.cs" Inherits="JivanBandhan4.ViewUserProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .profile-view-container {
            background: linear-gradient(135deg, #f8f9ff 0%, #eef2ff 50%, #f0f4ff 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .profile-view-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 300px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            clip-path: polygon(0 0, 100% 0, 100% 70%, 0 100%);
            z-index: 0;
        }
        
        .profile-header-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            color: #2c3e50;
            border-radius: 25px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.1);
            position: relative;
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 1;
        }
        
        .profile-main-layout {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 30px;
            margin-top: 20px;
            position: relative;
            z-index: 1;
        }
        
        .profile-sidebar {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            border-radius: 25px;
            padding: 25px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            height: fit-content;
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
        }
        
        .profile-content {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            border-radius: 25px;
            padding: 35px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
        }
        
        /* Profile Photo Flip Effect */
        .profile-photo-flip-container {
            perspective: 1000px;
            width: 280px;
            height: 280px;
            margin: 0 auto 25px;
            cursor: pointer;
        }

        .profile-photo-flip-inner {
            position: relative;
            width: 100%;
            height: 100%;
            text-align: center;
            transition: transform 0.8s;
            transform-style: preserve-3d;
        }

        .profile-photo-flip-container:hover .profile-photo-flip-inner {
            transform: rotateY(180deg);
        }

        .profile-photo-front, .profile-photo-back {
            position: absolute;
            width: 100%;
            height: 100%;
            backface-visibility: hidden;
            border-radius: 20px;
            border: 8px solid rgba(255,255,255,0.9);
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
        }

        .profile-photo-back {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: rotateY(180deg);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 20px;
            text-align: center;
        }

        .profile-photo-back-content h4 {
            color: white;
            margin-bottom: 10px;
            font-size: 1.2rem;
        }

        .profile-photo-back-content p {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
            margin-bottom: 5px;
        }

        .user-photo-extra-large {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 12px;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 4px;
            cursor: pointer;
        }
        
        .profile-name-large {
            font-size: 2rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
            text-align: center;
        }
        
        .profile-basic-info {
            background: rgba(248,249,250,0.7);
            padding: 20px;
            border-radius: 20px;
            margin: 20px 0;
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid rgba(0,0,0,0.1);
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-value {
            color: #6c757d;
            text-align: right;
        }

        /* Platinum Member Badge */
        .platinum-badge {
            background: linear-gradient(135deg, #e5e4e2 0%, #d4af37 50%, #e5e4e2 100%);
            color: #2c3e50;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.8rem;
            margin-bottom: 15px;
            text-align: center;
            border: 2px solid #d4af37;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
            animation: platinum-glow 2s infinite alternate;
        }

        @keyframes platinum-glow {
            from { box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3); }
            to { box-shadow: 0 4px 25px rgba(212, 175, 55, 0.6); }
        }

        .contact-number-platinum {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 12px;
            border-radius: 15px;
            margin: 15px 0;
            text-align: center;
            font-weight: bold;
            font-size: 1.1rem;
            border: 2px solid #fff;
            box-shadow: 0 5px 20px rgba(40, 167, 69, 0.4);
            animation: contact-pulse 3s infinite;
        }

        @keyframes contact-pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.02); }
            100% { transform: scale(1); }
        }

        .contact-info-restricted {
            background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
            color: white;
            padding: 12px;
            border-radius: 15px;
            margin: 15px 0;
            text-align: center;
            font-weight: bold;
            font-size: 1rem;
            border: 2px solid #fff;
            box-shadow: 0 5px 20px rgba(255, 193, 7, 0.4);
        }
        
        .platinum-info-message {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            padding: 10px 15px;
            border-radius: 15px;
            margin: 10px 0;
            text-align: center;
            font-size: 0.9rem;
            border: 2px solid #fff;
        }
        
        .section-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%) 1;
            padding-bottom: 15px;
            margin: 30px 0 20px 0;
            font-size: 1.5rem;
            font-weight: bold;
            position: relative;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .detail-card {
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            border-radius: 20px;
            padding: 25px;
            border: 1px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            backdrop-filter: blur(5px);
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin: 30px 0;
            flex-wrap: wrap;
        }
        
        .btn-profile-action {
            padding: 15px 25px;
            border: none;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            min-width: 160px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-interest {
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(214, 51, 132, 0.4);
        }
        
        .btn-message {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-shortlist {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }

        /* Block & Report Button Styles for View Profile */
        .btn-block {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }

        .btn-report {
            background: linear-gradient(135deg, #fd7e14 0%, #e55a00 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(253, 126, 20, 0.4);
        }

        .block-report-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid rgba(0,0,0,0.1);
        }

        .btn-block-report-large {
            padding: 12px 20px;
            border: none;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-bottom: 10px;
            position: relative;
            overflow: hidden;
        }

        .btn-block-report-large:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .online-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 15px;
        }
        
        .online {
            background: rgba(81, 207, 102, 0.2);
            color: #2d8a3e;
            border: 1px solid rgba(81, 207, 102, 0.3);
        }
        
        .offline {
            background: rgba(108, 117, 125, 0.2);
            color: #495057;
            border: 1px solid rgba(108, 117, 125, 0.3);
        }
        
        .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
        }
        
        .online .status-dot {
            background: #51cf66;
            animation: pulse-online 2s infinite;
        }
        
        .offline .status-dot {
            background: #6c757d;
        }

        /* Photo Gallery Styles */
        .photo-gallery-section {
            margin: 30px 0;
        }

        .gallery-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #667eea 0%, #764ba2 100%) 1;
            padding-bottom: 12px;
            margin: 25px 0 15px 0;
            font-size: 1.3rem;
            font-weight: bold;
        }

        .photo-gallery {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .gallery-item {
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            border: 3px solid transparent;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3px;
            aspect-ratio: 1;
        }

        .gallery-item:hover {
            transform: translateY(-8px) scale(1.05);
            box-shadow: 0 15px 40px rgba(0,0,0,0.25);
            border-color: rgba(102, 126, 234, 0.5);
        }

        .gallery-photo {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 12px;
            transition: all 0.4s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%);
        }

        .gallery-item:hover .gallery-photo {
            transform: scale(1.1);
        }

        .photo-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.7));
            padding: 10px;
            color: white;
            font-size: 0.8rem;
            opacity: 0;
            transition: all 0.3s ease;
            transform: translateY(10px);
        }

        .gallery-item:hover .photo-overlay {
            opacity: 1;
            transform: translateY(0);
        }

        /* Fullscreen Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.95);
            backdrop-filter: blur(10px);
        }

        .modal-content {
            position: relative;
            margin: auto;
            display: block;
            width: auto;
            max-width: 90%;
            max-height: 90%;
            top: 50%;
            transform: translateY(-50%);
            border-radius: 15px;
            box-shadow: 0 25px 80px rgba(0,0,0,0.5);
            animation: zoomIn 0.3s ease;
        }

        @keyframes zoomIn {
            from { transform: translateY(-50%) scale(0.7); opacity: 0; }
            to { transform: translateY(-50%) scale(1); opacity: 1; }
        }

        .close-modal {
            position: absolute;
            top: 20px;
            right: 30px;
            color: white;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
            z-index: 10001;
            background: rgba(0,0,0,0.5);
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .close-modal:hover {
            background: rgba(220, 53, 69, 0.8);
            transform: scale(1.1);
        }

        .modal-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            font-size: 24px;
            padding: 15px;
            cursor: pointer;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .modal-nav:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-50%) scale(1.1);
        }

        .prev-nav {
            left: 20px;
        }

        .next-nav {
            right: 20px;
        }

        .modal-counter {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            color: white;
            background: rgba(0,0,0,0.5);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            backdrop-filter: blur(10px);
        }

        .no-photos-message {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
            background: rgba(248,249,250,0.7);
            border-radius: 15px;
            border: 2px dashed #dee2e6;
        }

        .no-photos-message i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: #adb5bd;
        }

        @keyframes pulse-online {
            0% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(81, 207, 102, 0); }
            100% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0); }
        }

        @media (max-width: 992px) {
            .profile-main-layout {
                grid-template-columns: 1fr;
            }
            
            .profile-photo-flip-container {
                width: 220px;
                height: 220px;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-profile-action {
                width: 100%;
                max-width: 300px;
            }
            
            .photo-gallery {
                grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .profile-header-banner {
                padding: 20px;
            }
            
            .profile-content {
                padding: 25px;
            }
            
            .profile-sidebar {
                padding: 20px;
            }
            
            .profile-photo-flip-container {
                width: 200px;
                height: 200px;
            }
            
            .profile-name-large {
                font-size: 1.7rem;
            }
            
            .modal-content {
                max-width: 95%;
                max-height: 80%;
            }
            
            .modal-nav {
                width: 40px;
                height: 40px;
                font-size: 20px;
            }
            
            .close-modal {
                font-size: 30px;
                width: 40px;
                height: 40px;
            }
        }
    </style>

    <div class="profile-view-container">
        <div class="container">
            <!-- Profile Header -->
            <div class="profile-header-banner">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font">Profile Details</h1>
                        <p class="marathi-font mb-0">Complete profile information</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <asp:Button ID="btnBack" runat="server" Text="⬅ Back to Dashboard" 
                            CssClass="btn btn-secondary marathi-font" OnClick="btnBack_Click" />
                    </div>
                </div>
            </div>

            <!-- Main Profile Layout -->
            <div class="profile-main-layout">
                <!-- Left Sidebar -->
                <div class="profile-sidebar">
                    <!-- Platinum Membership Badge -->
                    <asp:Panel ID="pnlPlatinumBadge" runat="server" CssClass="platinum-badge marathi-font" Visible="false">
                        ⭐ PLATINUM MEMBER - Contact Number Visible
                    </asp:Panel>

                    <!-- Contact Number for Platinum Members -->
                    <asp:Panel ID="pnlContactNumber" runat="server" CssClass="contact-number-platinum marathi-font" Visible="false">
                        <i class="fas fa-phone"></i> Contact: 
                        <asp:Label ID="lblContactNumber" runat="server" Text=""></asp:Label>
                    </asp:Panel>

                    <!-- Contact Restricted Message -->
                    <asp:Panel ID="pnlContactRestricted" runat="server" CssClass="contact-info-restricted marathi-font" Visible="false">
                        <i class="fas fa-info-circle"></i> Contact number available only for Platinum members
                    </asp:Panel>

                    <!-- Platinum Info Message -->
                    <asp:Panel ID="pnlPlatinumInfo" runat="server" CssClass="platinum-info-message marathi-font" Visible="false">
                        <i class="fas fa-crown"></i> Upgrade to Platinum to view contact numbers
                    </asp:Panel>

                    <!-- Flip Profile Photo Container -->
                    <div class="profile-photo-flip-container">
                        <div class="profile-photo-flip-inner">
                            <div class="profile-photo-front">
                                <asp:Image ID="imgProfileLarge" runat="server" CssClass="user-photo-extra-large" 
                                    ImageUrl="~/Images/default-profile.jpg" 
                                    onerror="this.src='Images/default-profile.jpg'"
                                    onclick="openModal(0)" />
                            </div>
                            <div class="profile-photo-back">
                                <div class="profile-photo-back-content">
                                    <h4 class="marathi-font">प्रोफाइल तपशील</h4>
                                    <p class="marathi-font"><strong>नाव:</strong> <asp:Label ID="lblFlipName" runat="server" Text=""></asp:Label></p>
                                    <p class="marathi-font"><strong>वय:</strong> <asp:Label ID="lblFlipAge" runat="server" Text=""></asp:Label></p>
                                    <p class="marathi-font"><strong>ठिकाण:</strong> <asp:Label ID="lblFlipLocation" runat="server" Text=""></asp:Label></p>
                                    <p class="marathi-font"><strong>व्यवसाय:</strong> <asp:Label ID="lblFlipOccupation" runat="server" Text=""></asp:Label></p>
                                    <p class="marathi-font"><small>फोटोवर क्लिक करा मोठे पहाण्यासाठी</small></p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Online Status -->
                    <div class="online-status marathi-font" id="onlineStatus" runat="server">
                        <div class="status-dot"></div>
                        <span id="statusText" runat="server">Online</span>
                    </div>
                    
                    <div class="profile-name-large marathi-font">
                        <asp:Label ID="lblFullName" runat="server" Text=""></asp:Label>
                    </div>
                    
                    <!-- Basic Information -->
                    <div class="profile-basic-info">
                        <div class="info-item marathi-font">
                            <span class="info-label">Profile ID:</span>
                            <span class="info-value">
                                <asp:Label ID="lblProfileID" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Age:</span>
                            <span class="info-value">
                                <asp:Label ID="lblAge" runat="server" Text=""></asp:Label> Years
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Height:</span>
                            <span class="info-value">
                                <asp:Label ID="lblHeight" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <!-- Phone Number will be displayed here only for Platinum members -->
                        <asp:Panel ID="pnlPhoneBasicInfo" runat="server" Visible="false">
                            <div class="info-item marathi-font">
                                <span class="info-label">Phone Number:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPhone" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </asp:Panel>
                        <div class="info-item marathi-font">
                            <span class="info-label">Religion:</span>
                            <span class="info-value">
                                <asp:Label ID="lblReligion" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Caste:</span>
                            <span class="info-value">
                                <asp:Label ID="lblCaste" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Location:</span>
                            <span class="info-value">
                                <asp:Label ID="lblLocation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Occupation:</span>
                            <span class="info-value">
                                <asp:Label ID="lblOccupation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Education:</span>
                            <span class="info-value">
                                <asp:Label ID="lblEducation" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <div class="info-item marathi-font">
                            <span class="info-label">Marital Status:</span>
                            <span class="info-value">
                                <asp:Label ID="lblMaritalStatus" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <asp:Button ID="btnSendInterest" runat="server" Text="💝 Send Interest" 
                            CssClass="btn-profile-action btn-interest marathi-font" OnClientClick="sendInterest(); return false;" />
                        <asp:Button ID="btnSendMessage" runat="server" Text="💌 Send Message" 
                            CssClass="btn-profile-action btn-message marathi-font" OnClientClick="sendMessage(); return false;" />
                        <asp:Button ID="btnShortlist" runat="server" Text="⭐ Shortlist" 
                            CssClass="btn-profile-action btn-shortlist marathi-font" OnClientClick="shortlistProfile(); return false;" />
                    </div>

                    <!-- Block & Report Section -->
                    <div class="block-report-section">
                        <h5 class="marathi-font text-center mb-3">Safety & Privacy</h5>
                        <button class="btn-block-report-large btn-block marathi-font" 
                            onclick='blockUser()'>
                            🚫 Block User
                        </button>
                        <button class="btn-block-report-large btn-report marathi-font" 
                            onclick='reportUser()'>
                            ⚠ Report Profile
                        </button>
                    </div>
                </div>
                
                <!-- Right Content -->
                <div class="profile-content">
                    <!-- Photo Gallery Section -->
                    <div class="photo-gallery-section">
                        <h3 class="gallery-title marathi-font">
                            <i class="fas fa-images"></i> Photo Gallery
                        </h3>
                        
                        <div class="photo-gallery" id="photoGallery" runat="server">
                            <!-- Photos will be dynamically added here -->
                        </div>
                        
                        <asp:Panel ID="pnlNoPhotos" runat="server" CssClass="no-photos-message" Visible="false">
                            <i class="fas fa-camera"></i>
                            <h5 class="marathi-font">No Photos Available</h5>
                            <p class="marathi-font">This user hasn't uploaded any photos yet.</p>
                        </asp:Panel>
                    </div>

                    <!-- Personal Information -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-user"></i> Personal Information
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #d63384; margin-bottom: 15px;">
                                <i class="fas fa-info-circle"></i> Basic Details
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Full Name:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalFullName" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Gender:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblGender" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Date of Birth:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblDOB" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Marital Status:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalMaritalStatus" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #667eea; margin-bottom: 15px;">
                                <i class="fas fa-heart"></i> Religious Details
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Religion:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalReligion" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Caste:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblPersonalCaste" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Sub Caste:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblSubCaste" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Manglik:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblManglik" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Education & Career -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-graduation-cap"></i> Education & Career
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #28a745; margin-bottom: 15px;">
                                <i class="fas fa-university"></i> Education
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Highest Education:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblHighestEducation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Education Field:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblEducationField" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">College/University:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblCollege" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #ffc107; margin-bottom: 15px;">
                                <i class="fas fa-briefcase"></i> Career
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblCareerOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Occupation Field:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblOccupationField" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Annual Income:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblAnnualIncome" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Family Information -->
                    <h3 class="section-title marathi-font">
                        <i class="fas fa-home"></i> Family Information
                    </h3>
                    
                    <div class="detail-grid">
                        <div class="detail-card">
                            <h5 class="marathi-font" style="color: #dc3545; margin-bottom: 15px;">
                                <i class="fas fa-users"></i> Family Background
                            </h5>
                            <div class="info-item marathi-font">
                                <span class="info-label">Family Type:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblFamilyType" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Father's Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblFatherOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="info-item marathi-font">
                                <span class="info-label">Mother's Occupation:</span>
                                <span class="info-value">
                                    <asp:Label ID="lblMotherOccupation" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Fullscreen Photo Modal -->
    <div id="photoModal" class="modal">
        <span class="close-modal" onclick="closeModal()">&times;</span>
        <button class="modal-nav prev-nav" onclick="changePhoto(-1)">&#10094;</button>
        <button class="modal-nav next-nav" onclick="changePhoto(1)">&#10095;</button>
        <img class="modal-content" id="modalImage">
        <div class="modal-counter" id="modalCounter">1 / 1</div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnViewedUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnUserPhotos" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // Global variables for photo gallery
        let currentPhotoIndex = 0;
        let userPhotos = [];

        // Initialize photo gallery from hidden field
        function initializePhotoGallery() {
            const photosData = document.getElementById('<%= hdnUserPhotos.ClientID %>').value;
            const profilePhotoUrl = document.getElementById('<%= imgProfileLarge.ClientID %>').src;

            if (photosData) {
                userPhotos = JSON.parse(photosData);
            }

            // Always include profile photo as first image
            if (profilePhotoUrl && !userPhotos.some(photo => photo.url === profilePhotoUrl)) {
                userPhotos.unshift({
                    url: profilePhotoUrl,
                    title: 'Profile Photo',
                    IsProfilePhoto: true
                });
            }
        }

        // Open modal with specific photo - Improved version
        function openModal(index) {
            if (userPhotos.length === 0) {
                // If no gallery photos, just open the profile photo
                const modal = document.getElementById('photoModal');
                const modalImg = document.getElementById('modalImage');
                const modalCounter = document.getElementById('modalCounter');

                modal.style.display = 'block';
                modalImg.src = document.getElementById('<%= imgProfileLarge.ClientID %>').src;
                modalCounter.textContent = '1 / 1';

                // Prevent body scroll
                document.body.style.overflow = 'hidden';
                return;
            }

            currentPhotoIndex = index;
            const modal = document.getElementById('photoModal');
            const modalImg = document.getElementById('modalImage');
            const modalCounter = document.getElementById('modalCounter');

            modal.style.display = 'block';
            modalImg.src = userPhotos[currentPhotoIndex].url;
            modalCounter.textContent = `${currentPhotoIndex + 1} / ${userPhotos.length}`;

            // Prevent body scroll
            document.body.style.overflow = 'hidden';
        }

        // Close modal
        function closeModal() {
            const modal = document.getElementById('photoModal');
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        // Change photo in modal
        function changePhoto(direction) {
            currentPhotoIndex += direction;

            // Loop around
            if (currentPhotoIndex >= userPhotos.length) {
                currentPhotoIndex = 0;
            } else if (currentPhotoIndex < 0) {
                currentPhotoIndex = userPhotos.length - 1;
            }

            const modalImg = document.getElementById('modalImage');
            const modalCounter = document.getElementById('modalCounter');

            modalImg.src = userPhotos[currentPhotoIndex].url;
            modalCounter.textContent = `${currentPhotoIndex + 1} / ${userPhotos.length}`;
        }

        // Keyboard navigation
        document.addEventListener('keydown', function (event) {
            const modal = document.getElementById('photoModal');
            if (modal.style.display === 'block') {
                if (event.key === 'Escape') {
                    closeModal();
                } else if (event.key === 'ArrowLeft') {
                    changePhoto(-1);
                } else if (event.key === 'ArrowRight') {
                    changePhoto(1);
                }
            }
        });

        // Close modal when clicking outside image
        document.getElementById('photoModal').addEventListener('click', function (event) {
            if (event.target === this) {
                closeModal();
            }
        });

        // Send Interest Function
        function sendInterest() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to send interest');
                return;
            }

            if (confirm('Are you interested in this profile?')) {
                const button = document.getElementById('<%= btnSendInterest.ClientID %>');
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/SendInterest",
                    data: JSON.stringify({
                        sentByUserID: parseInt(currentUserID),
                        targetUserID: parseInt(viewedUserID)
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Interest Sent';
                            button.style.background = '#28a745';
                            button.disabled = true;
                            showNotification('Interest sent successfully!', 'success');
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Sent';
                            button.style.background = '#ffc107';
                            button.disabled = true;
                            showNotification('You have already sent interest to this profile!', 'info');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending interest!', 'error');
                    }
                });
            }
        }

        // Send Message Function
        function sendMessage() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to send message');
                return;
            }

            const message = prompt('Enter your message:');
            if (message) {
                const button = document.getElementById('<%= btnSendMessage.ClientID %>');
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/SendMessage",
                    data: JSON.stringify({
                        fromUserID: parseInt(currentUserID),
                        toUserID: parseInt(viewedUserID),
                        messageText: message
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Message Sent';
                            button.style.background = '#28a745';
                            button.disabled = true;
                            showNotification('Message sent successfully!', 'success');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending message!', 'error');
                    }
                });
            }
        }

        // Shortlist Profile Function
        function shortlistProfile() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to shortlist profile');
                return;
            }

            const button = document.getElementById('<%= btnShortlist.ClientID %>');
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            $.ajax({
                type: "POST",
                url: "ViewUserProfile.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: parseInt(viewedUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = '#28a745';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = '#ffc107';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Block User Function for View Profile
        function blockUser() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to block user');
                return;
            }

            if (confirm('Are you sure you want to block this user? You will no longer see their profile and they will not be able to contact you.')) {
                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/BlockUser",
                    data: JSON.stringify({
                        blockedByUserID: parseInt(currentUserID),
                        blockedUserID: parseInt(viewedUserID)
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            showNotification('User blocked successfully! Redirecting...', 'success');
                            setTimeout(() => {
                                window.location.href = 'Dashboard.aspx';
                            }, 2000);
                        } else if (response.d === "exists") {
                            showNotification('You have already blocked this user!', 'info');
                        } else {
                            showNotification('Error blocking user!', 'error');
                        }
                    },
                    error: function () {
                        showNotification('Error blocking user!', 'error');
                    }
                });
            }
        }

        // Report User Function for View Profile
        function reportUser() {
            const viewedUserID = document.getElementById('<%= hdnViewedUserID.ClientID %>').value;
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            if (!currentUserID) {
                alert('Please login to report profile');
                return;
            }

            const reportReason = prompt('Please specify the reason for reporting this profile:');
            if (reportReason) {
                $.ajax({
                    type: "POST",
                    url: "ViewUserProfile.aspx/ReportUser",
                    data: JSON.stringify({
                        reportedByUserID: parseInt(currentUserID),
                        reportedUserID: parseInt(viewedUserID),
                        reportReason: reportReason
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            showNotification('Profile reported successfully! Our team will review this profile.', 'success');
                        } else {
                            showNotification('Error reporting profile!', 'error');
                        }
                    },
                    error: function () {
                        showNotification('Error reporting profile!', 'error');
                    }
                });
            }
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px 20px';
            notification.style.borderRadius = '10px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';

            if (type === 'success') {
                notification.style.background = 'linear-gradient(135deg, #28a745, #20c997)';
            } else if (type === 'error') {
                notification.style.background = 'linear-gradient(135deg, #dc3545, #c82333)';
            } else if (type === 'info') {
                notification.style.background = 'linear-gradient(135deg, #17a2b8, #138496)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 3000);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize photo gallery
            initializePhotoGallery();

            // Set random online status (for demo)
            const onlineStatus = document.getElementById('<%= onlineStatus.ClientID %>');
            const statusText = document.getElementById('<%= statusText.ClientID %>');
            const isOnline = Math.random() > 0.5;

            if (onlineStatus && statusText) {
                if (isOnline) {
                    onlineStatus.className = 'online-status marathi-font online';
                    statusText.textContent = 'Online Now';
                } else {
                    onlineStatus.className = 'online-status marathi-font offline';
                    statusText.textContent = 'Offline';
                }
            }
        });
    </script>
</asp:Content>
--%>
