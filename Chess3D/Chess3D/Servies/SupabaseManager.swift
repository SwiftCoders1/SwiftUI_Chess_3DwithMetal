//
//  SupabaseManager.swift
//  Chess3D
//
//  Created by Prajjwal on 07/08/26.
//
import Supabase

enum SupabaseManager {
    static let client = SupabaseClient(
        supabaseURL: Secrets.supabaseURL!,
        supabaseKey: Secrets.supabaseAnonKey
        
    )
}
