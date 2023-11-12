import {FormControl, Textarea} from '@chakra-ui/react';
import React, {useState} from "react";
import axios from "axios";

interface PublishMessageFormProps {
    busType: string;
}

export const PublishMessageForm: React.FC<PublishMessageFormProps> = ({ busType }) => {
    const [message, setMessage] = useState('');
    const backendUrl = process.env.NEXT_PUBLIC_BACKEND_URL || '';

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault(); // Prevent the default form submission behaviour
        try {
            await axios.post(backendUrl + '/publish_message', {
                sender: 'admin web',
                message: message,
                bus: busType,
            });
            console.log('Message published');
        } catch (error) {
            console.error('Error publishing the message:', error);
        } finally {
            setMessage(''); // Clear the message input field after submission regardless of success or error
        }
    };

    const handleKeyDown = (e: React.KeyboardEvent) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault(); // Prevent new line
            // noinspection JSIgnoredPromiseFromCall
            handleSubmit(e as any); // Trigger form submission
        }
    };

    return (
        <FormControl as="form" onSubmit={handleSubmit}>
            <Textarea
                background={"white"}
                value={message}
                onChange={e => setMessage(e.target.value)}
                onKeyDown={handleKeyDown}
                placeholder={`Send new message`}
            />
        </FormControl>
    );
};
