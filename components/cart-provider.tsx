 "use client";
import {createContext,useContext,useState} from "react";
export type CartItem={id:string;name:string;price:number;image:string;qty:number;restaurant:string};
type CartContextValue={items:CartItem[];add:(item:CartItem)=>void;remove:(id:string)=>void;inc:(id:string)=>void;dec:(id:string)=>void;total:number};
const C=createContext<CartContextValue|null>(null);
export function CartProvider({children}:{children:React.ReactNode}){const[items,setItems]=useState<CartItem[]>([]);
 const add=(x:CartItem)=>setItems(v=>{const f=v.find(i=>i.id===x.id);return f?v.map(i=>i.id===x.id?{...i,qty:i.qty+1}:i):[...v,{...x,qty:1}]});
 const remove=(id:string)=>setItems(v=>v.filter(i=>i.id!==id)); const inc=(id:string)=>setItems(v=>v.map(i=>i.id===id?{...i,qty:i.qty+1}:i)); const dec=(id:string)=>setItems(v=>v.flatMap(i=>i.id===id?(i.qty>1?[{...i,qty:i.qty-1}]:[]):[i]));
 return <C.Provider value={{items,add,remove,inc,dec,total:items.reduce((s,i)=>s+i.price*i.qty,0)}}>{children}</C.Provider>}
export function useCart(){const context=useContext(C);if(!context)throw new Error("useCart must be used within CartProvider");return context}