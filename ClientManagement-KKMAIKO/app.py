from flask import Flask, render_template, jsonify, request
import mysql.connector
import os
import base64
import uuid
import re

app = Flask(__name__)

#Database connection
def get_db_connection():
    return mysql.connector.connect(
        host='127.0.0.1',
        user='root',       #Default XAMPP username
        password='',       #Default XAMPP password is blank
        database='nail_salon-db' #Database name
    )

#ROUTES
@app.route('/')
def index():
    return render_template('nail_salon_dashboard.html')

#REST API:Gets all the clients
@app.route('/api/clients', methods=['GET'])
def get_clients():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        #Pull records from database
        cursor.execute("""
            SELECT 
                c.Client_ID, 
                c.Full_Name, 
                c.Phone, 
                c.Email_Add, 
                c.Soc_Med_Acc, 
                c.Birthday, 
                c.Address, 
                c.Favorite_Music, 
                c.Date_Registered,
                (
                    SELECT a.STATUS 
                    FROM appointment a 
                    WHERE a.Client_ID = c.Client_ID 
                    ORDER BY a.Appointment_Date DESC, a.Booking_Date_Time DESC 
                    LIMIT 1
                ) AS Status
            FROM client c
        """)
        db_clients = cursor.fetchall()
        
        clients = []
        for c in db_clients:
            status = c['Status'] if c['Status'] is not None else 'active'
            #Normalize case
            if status and status.lower() == 'cancelled':
                display_status = 'cancelled'
            else:
                display_status = 'active'
            
            clients.append({
                'id': c['Client_ID'],
                'fullName': c['Full_Name'] or '',
                'phone': c['Phone'] or '',
                'email': c['Email_Add'] or '',
                'socialMedia': c['Soc_Med_Acc'] or '',
                'birthday': c['Birthday'].strftime('%Y-%m-%d') if c['Birthday'] else '',
                'address': c['Address'] or '',
                'favoriteMusic': c['Favorite_Music'] or '',
                'dateRegistered': c['Date_Registered'].strftime('%Y-%m-%d') if c['Date_Registered'] else None,
                'status': display_status
            })
            
        cursor.close()
        conn.close()
        return jsonify(clients), 200
    except Exception as err:
        print(f"\nCRITICAL GET CLIENTS ERROR: {err}\n")
        return jsonify({'error': str(err)}), 500

@app.route('/api/discounts', methods=['GET'])
def get_discounts():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM discount")
        discounts = cursor.fetchall()
        return jsonify(discounts)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

@app.route('/api/clients/<int:client_id>/toggle-status', methods=['PUT'])
def toggle_client_status(client_id):
    """Toggle the STATUS of the client's most recent appointment."""
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
    
    cursor = conn.cursor(dictionary=True)
    try:
        # Find the most recent appointment for this client
        cursor.execute("""
            SELECT Appointment_ID, STATUS 
            FROM appointment
            WHERE Client_ID = %s
            ORDER BY Appointment_Date DESC, Booking_Date_Time DESC
            LIMIT 1
        """, (client_id,))
        appt = cursor.fetchone()
        
        if not appt:
            return jsonify({'error': 'No appointment found for this client'}), 404
        
        # Determine new status
        current = appt['STATUS']
        new_status = 'Cancelled' if current == 'Completed' else 'Completed'
        
        # Update the appointment
        cursor.execute("""
            UPDATE appointment 
            SET STATUS = %s 
            WHERE Appointment_ID = %s
        """, (new_status, appt['Appointment_ID']))
        conn.commit()
        
        return jsonify({
            'message': f'Client status updated to {new_status.lower()}',
            'new_status': new_status.lower()
        }), 200
        
    except Exception as e:
        conn.rollback()
        print(f"\nTOGGLE STATUS ERROR: {e}\n")
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()


#REST API: adds new client
@app.route('/api/clients', methods=['POST'])
def add_client():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    
    sql = """
        INSERT INTO client (
            Client_ID, Full_Name, Phone, Email_Add, Soc_Med_Acc, Birthday, Address, Favorite_Music, Date_Registered
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    
    values = (
        data['id'],
        data['fullName'],
        data['phone'] if data.get('phone') else None,
        data['email'] if data.get('email') else None,
        data['socialMedia'] if data.get('socialMedia') else None,
        data['birthday'] if data.get('birthday') else None,
        data['address'] if data.get('address') else None,
        data['favoriteMusic'] if data.get('favoriteMusic') else None,
        data['dateRegistered']
    )
    
    try:
        cursor.execute(sql, values)
        conn.commit()
        response = jsonify({'message': 'Client saved successfully!'}), 201
    except mysql.connector.Error as err:
        print(f"\n DATABASE ERROR: {err}\n")
        response = jsonify({'error': str(err)}), 400
    finally:
        cursor.close()
        conn.close()
        
    return response

#REST API:Updates and existing client(reservation)
@app.route('/api/clients/<int:client_id>', methods=['PUT'])
def update_client(client_id):
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    
    sql = """
        UPDATE client SET 
            Full_Name = %s, Phone = %s, Email_Add = %s, Soc_Med_Acc = %s, Birthday = %s, Address = %s, Favorite_Music = %s
        WHERE Client_ID = %s
    """
    values = (
        data['fullName'],
        data['phone'] if data.get('phone') else None,
        data['email'] if data.get('email') else None,
        data['socialMedia'] if data.get('socialMedia') else None,
        data['birthday'] if data.get('birthday') else None,
        data['address'] if data.get('address') else None,
        data['favoriteMusic'] if data.get('favoriteMusic') else None,
        client_id
    )
    
    try:
        cursor.execute(sql, values)
        conn.commit()
        response = jsonify({'message': 'Client updated successfully!'}), 200
    except mysql.connector.Error as err:
        print(f"\nUPDATE DATABASE ERROR: {err}\n")
        response = jsonify({'error': str(err)}), 400
    finally:
        cursor.close()
        conn.close()
        
    return response

#REST API: Deletes a Client
@app.route('/api/clients/<int:client_id>', methods=['DELETE'])
def delete_client(client_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        #Warning: If this client has existing appointments or transactions 
        #MySQL will block the deletion due to Foreign Key constraints
        cursor.execute("DELETE FROM client WHERE Client_ID = %s", (client_id,))
        conn.commit()
        response = jsonify({'message': 'Client deleted successfully!'}), 200
    except mysql.connector.Error as err:
        print(f"\n DELETE DATABASE ERROR: {err}\n")
        #For the foreign Key constraint error
        response = jsonify({'error': str(err)}), 400
    finally:
        cursor.close()
        conn.close()

    return response


#REST API:Save a New Visit
@app.route('/api/visits', methods=['POST'])
def add_visit():
    data = request.json or {}
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        conn.start_transaction()
        
        #0.STRICT TYPE UNWRAPPING(prevents the 'dict' crash)
        raw_client = data.get('clientId')
        client_id = raw_client.get('id') if isinstance(raw_client, dict) else raw_client
        
        date_str = data.get('date')#expected format: YYYY-MM-DD
        
        if not client_id or not date_str:
            return jsonify({'error': 'Missing client ID or date'}), 400
        
        #3. DESIGNS & IMAGE UPLOAD
        designs = data.get('designs') or {}
        image_b64 = data.get('imageBase64')
        image_file_path = None
        
        #Design description as filename
        all_design = designs.get('all')
        all_design_str = all_design.get('value') if isinstance(all_design, dict) else all_design
        
        if all_design_str and str(all_design_str).strip():
            design_desc = str(all_design_str).strip()
        else:
            design_desc = "N/A"
            
        #Save the image file 
        if image_b64:
            try:
                #Strip the base64 metadata header to get the pure file string
                header, encoded = image_b64.split(",", 1)
                ext = header.split(";")[0].split("/")[1] 
                
                #Replaces spaces and weird characters with underscores
                safe_name = re.sub(r'[^a-zA-Z0-9_\-]', '_', design_desc).strip('_')
                
                #Incase invalid or missing name
                if not safe_name or safe_name == 'N_A':
                    safe_name = f"design_{uuid.uuid4().hex[:8]}"
                    
                filename = f"{safe_name}.{ext}"
                upload_dir = os.path.join(app.root_path, 'static', 'uploads')
                os.makedirs(upload_dir, exist_ok=True)
                
                filepath = os.path.join(upload_dir, filename)
                
                #Prevent overwriting
                if os.path.exists(filepath):
                    filename = f"{safe_name}_{uuid.uuid4().hex[:6]}.{ext}"
                    filepath = os.path.join(upload_dir, filename)
                
                with open(filepath, "wb") as fh:
                    fh.write(base64.b64decode(encoded))
                
                image_file_path = f"/static/uploads/{filename}"
            except Exception as img_e:
                print(f"IMAGE UPLOAD ERROR: {img_e}")

        #Save to Database
        # Check if a design with the same description already exists
        cursor.execute("""
            SELECT Design_ID, Times_Used, Client_ID 
            FROM design_inspo 
            WHERE Design_Description = %s
        """, (design_desc,))
        existing_design = cursor.fetchone()

        if existing_design:
            # Design exists: increment Times_Used
            design_id = existing_design['Design_ID']
            cursor.execute("""
                UPDATE design_inspo 
                SET Times_Used = Times_Used + 1 
                WHERE Design_ID = %s
            """, (design_id,))
        else:
            # New design: insert with Date_Added, Times_Used = 1, Client_ID = current client
            cursor.execute("""
                INSERT INTO design_inspo 
                (Design_Description, Image_File_Path, Client_ID, Date_Added, Times_Used)
                VALUES (%s, %s, %s, NOW(), 1)
            """, (design_desc, image_file_path, client_id))
            design_id = cursor.lastrowid

        #CREATE APPOINTMENT
        cursor.execute("""
            INSERT INTO appointment (Client_ID, Design_ID, Appointment_Date, Status) 
            VALUES (%s, %s, %s, 'Completed')
        """, (client_id, design_id, date_str))
        appointment_id = cursor.lastrowid

        #2. UPDATE NAIL SIZES
        nail_sizes = data.get('nailSizes') or {}
        
        #Helper function to unwrap size objects if they arrive as dicts
        def get_flat_size(ns_dict, key):
            val = ns_dict.get(key)
            return val.get('value') if isinstance(val, dict) else val

        l_thumb = get_flat_size(nail_sizes, 'LT')
        l_index = get_flat_size(nail_sizes, 'LI')
        l_middle = get_flat_size(nail_sizes, 'LM')
        l_ring = get_flat_size(nail_sizes, 'LR')
        l_pinky = get_flat_size(nail_sizes, 'LP')
        
        r_thumb = get_flat_size(nail_sizes, 'RT')
        r_index = get_flat_size(nail_sizes, 'RI')
        r_middle = get_flat_size(nail_sizes, 'RM')
        r_ring = get_flat_size(nail_sizes, 'RR')
        r_pinky = get_flat_size(nail_sizes, 'RP')
        
        if any([l_thumb, l_index, l_middle, l_ring, l_pinky, r_thumb, r_index, r_middle, r_ring, r_pinky]):
            cursor.execute("SELECT Size_ID FROM nail_size WHERE Client_ID = %s", (client_id,))
            existing_size = cursor.fetchone() is not None
    
            if existing_size:
                cursor.execute("""
                    UPDATE nail_size 
                    SET L_Thumb_Size=%s, L_Index_Size=%s, L_Middle_Size=%s, L_Ring_Size=%s, L_Pinky_Size=%s,
                        R_Thumb_Size=%s, R_Index_Size=%s, R_Middle_Size=%s, R_Ring_Size=%s, R_Pinky_Size=%s
                        Date_Measured=CURRENT_DATE()
                    WHERE Client_ID=%s
                """, (l_thumb, l_index, l_middle, l_ring, l_pinky, 
                      r_thumb, r_index, r_middle, r_ring, r_pinky, client_id))
            else:
                cursor.execute("""
                    INSERT INTO nail_size 
                    (Client_ID, L_Thumb_Size, L_Index_Size, L_Middle_Size, L_Ring_Size, L_Pinky_Size, 
                     R_Thumb_Size, R_Index_Size, R_Middle_Size, R_Ring_Size, R_Pinky_Size, Date_Measured))
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, CURRENT_DATE())
                """, (client_id, l_thumb, l_index, l_middle, l_ring, l_pinky, 
                      r_thumb, r_index, r_middle, r_ring, r_pinky))

	# 1.Handle services, transaction, history & DISCOUNTS
        selected_services = data.get('services') or []
        discount_id = data.get('discountId')
        discount_value = 0.0
        
        if discount_id:
            cursor.execute("SELECT Discount_Value FROM discount WHERE Discount_ID = %s", (discount_id,))
            discount_row = cursor.fetchone()
            if discount_row and discount_row['Discount_Value']:
                discount_value = float(discount_row['Discount_Value'])

        for srv in selected_services:
            srv_name = srv.get('name') if isinstance(srv, dict) else srv
            
            cursor.execute("SELECT Service_ID, Base_Price FROM service WHERE Service_Name = %s", (srv_name,))
            srv_row = cursor.fetchone()
            
            if srv_row:
                srv_id = srv_row['Service_ID']
                base_amount = float(srv_row['Base_Price'])
                
                #Base Amount - Discount Amount = Total Amount
                discount_amount = base_amount * (discount_value / 100.0) if discount_id else 0.0
                total_amount = base_amount - discount_amount
                
                cursor.execute("""
                    INSERT INTO transaction 
                    (Appointment_ID, Client_ID, Service_ID, Transaction_Date, Base_Amount, Discount_ID, Discount_Amount, Total_Amount)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                """, (appointment_id, client_id, srv_id, date_str, base_amount, discount_id, discount_amount, total_amount))

                cursor.execute("""
                    INSERT INTO history (Client_ID, Service_ID, Visit_Date)
                    VALUES (%s, %s, %s)
                """, (client_id, srv_id, date_str))

        conn.commit()
        return jsonify({'message': 'Visit integrated with full relational mapping!'}), 201

    except Exception as e:
        conn.rollback()
        print(f"\nSQL COMMIT ERROR: {e}\n")
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

#REST API: Get visit history for a client (or all visits)
@app.route('/api/visits', methods=['GET'])
def get_visits():
    """Return all visits with service, design, and nail size info."""
    client_id = request.args.get('clientId')
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        if client_id:
            # Fetch visits for a specific client
            cursor.execute("""
                SELECT 
                    a.Appointment_ID,
                    a.Appointment_Date AS date,
                    a.STATUS,
                    d.Design_Description AS design_description,
                    GROUP_CONCAT(DISTINCT s.Service_Name SEPARATOR ', ') AS service_names,
                    GROUP_CONCAT(DISTINCT t.Total_Amount SEPARATOR ', ') AS service_prices,
                    ns.L_Thumb_Size, ns.L_Index_Size, ns.L_Middle_Size, ns.L_Ring_Size, ns.L_Pinky_Size,
                    ns.R_Thumb_Size, ns.R_Index_Size, ns.R_Middle_Size, ns.R_Ring_Size, ns.R_Pinky_Size
                FROM appointment a
                LEFT JOIN design_inspo d ON a.Design_ID = d.Design_ID
                LEFT JOIN transaction t ON a.Appointment_ID = t.Appointment_ID
                LEFT JOIN service s ON t.Service_ID = s.Service_ID
                LEFT JOIN nail_size ns ON a.Client_ID = ns.Client_ID
                WHERE a.Client_ID = %s
                GROUP BY a.Appointment_ID
                ORDER BY a.Appointment_Date DESC
            """, (client_id,))
        else:
            # Fetch all visits (for analytics / recent visits)
            cursor.execute("""
                SELECT 
                    a.Appointment_ID,
                    a.Client_ID,
                    a.Appointment_Date AS date,
                    a.STATUS,
                    d.Design_Description AS design_description,
                    GROUP_CONCAT(DISTINCT s.Service_Name SEPARATOR ', ') AS service_names,
                    GROUP_CONCAT(DISTINCT t.Total_Amount SEPARATOR ', ') AS service_prices
                FROM appointment a
                LEFT JOIN design_inspo d ON a.Design_ID = d.Design_ID
                LEFT JOIN transaction t ON a.Appointment_ID = t.Appointment_ID
                LEFT JOIN service s ON t.Service_ID = s.Service_ID
                GROUP BY a.Appointment_ID
                ORDER BY a.Appointment_Date DESC
            """)
        
        rows = cursor.fetchall()
        visits = []
        for row in rows:
            # Build services array
            services = []
            if row.get('service_names'):
                names = row['service_names'].split(', ')
                prices = row.get('service_prices', '').split(', ') if row.get('service_prices') else []
                for i, name in enumerate(names):
                    price = float(prices[i]) if i < len(prices) else 0
                    services.append({'name': name, 'price': price})
            
            # Build designs object
            designs = {}
            if row.get('design_description') and row['design_description'] != 'N/A':
                designs['all'] = row['design_description']
            
            # Build nail sizes object (if present)
            nail_sizes = {}
            for finger in ['L_Thumb_Size','L_Index_Size','L_Middle_Size','L_Ring_Size','L_Pinky_Size',
                           'R_Thumb_Size','R_Index_Size','R_Middle_Size','R_Ring_Size','R_Pinky_Size']:
                if row.get(finger) is not None:
                    short = finger.replace('_Size','').replace('_','')
                    nail_sizes[short] = float(row[finger])
            
            visit = {
                'id': row['Appointment_ID'],
                'clientId': row.get('Client_ID'),
                'date': row['date'].strftime('%Y-%m-%d') if row['date'] else None,
                'status': row['STATUS'] or 'Completed',
                'services': services,
                'designs': designs,
                'nailSizes': nail_sizes
            }
            visits.append(visit)
        
        return jsonify(visits), 200
    except Exception as e:
        print(f"\nGET VISITS ERROR: {e}\n")
        return jsonify({'error': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

#Recent Visit Fix
@app.route('/api/recent-visits', methods=['GET'])
def recent_visits():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT 
            Client_ID, 
            Full_Name 
        FROM client 
        ORDER BY Client_ID DESC 
        LIMIT 3
    """)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify([
        {
            'id': r['Client_ID'],
            'name': r['Full_Name']
        }
        for r in rows
    ])

#Dashboard Analytics Summary
@app.route('/api/analytics', methods=['GET'])
def get_analytics():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        #1. Calculate Monthly Revenue (Sum from transactions)
        cursor.execute("""
            SELECT SUM(t.Total_Amount) AS monthly_revenue 
            FROM transaction t
            JOIN appointment a ON t.Appointment_ID = a.Appointment_ID
            WHERE a.STATUS = 'Completed'
              AND MONTH(t.Transaction_Date) = MONTH(CURRENT_DATE())
              AND YEAR(t.Transaction_Date) = YEAR(CURRENT_DATE())
        """)
        rev_res = cursor.fetchone()
        monthly_revenue = float(rev_res['monthly_revenue']) if rev_res and rev_res['monthly_revenue'] else 0.0
        
        #2.Count Cancellations(Count from appointments)
        cursor.execute("SELECT COUNT(*) AS cancel_count FROM appointment WHERE Status = 'Cancelled'")
        cancel_res = cursor.fetchone()
        cancel_count = cancel_res['cancel_count'] if cancel_res else 0
        
        #3.Total Visits(Count from history)
        cursor.execute("SELECT COUNT(Visit_ID) AS visit_count FROM history")
        visit_res = cursor.fetchone()
        total_visits = visit_res['visit_count'] if visit_res else 0

        #4.Top 3 Designs(Excluding "N/A" for multiple nail designs)
        cursor.execute("""
            SELECT 
                Design_Description AS name, 
                SUM(Times_Used) AS count
            FROM design_inspo
            GROUP BY Design_Description
            ORDER BY count DESC
            LIMIT 3
        """)
        top_designs = cursor.fetchall()
        
        cursor.close()
        
        return jsonify({
            'monthlyRevenue': monthly_revenue,
            'cancellations': cancel_count,
            'totalVisits': total_visits,
            'topDesigns': top_designs
        }), 200
        
    except Exception as e:
        print(f"\nANALYTICS ENGINE CRASH: {e}\n")
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
